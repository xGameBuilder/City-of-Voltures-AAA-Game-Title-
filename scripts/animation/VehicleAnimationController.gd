# Animation controller for vehicle animations
# Handles door open/close, headlight flicker, hood pop, engine states
extends BaseAnimationController
class_name VehicleAnimationController

# Animation states - non-locomotion specific (vehicles are driven, not animated walking)
const STATE_IDLE = "Idle"
const STATE_ENGINE_START = "EngineStart"
const STATE_ENGINE_RUNNING = "EngineRunning"
const STATE_DOOR_OPEN = "DoorOpen"
const STATE_DOOR_CLOSE = "DoorClose"
const STATE_HOOD_POP = "HoodPop"
const STATE_HOOD_CLOSE = "HoodClose"
const STATE_HEADLIGHT_FLICKER = "HeadlightFlicker"
const STATE_BREAKDOWN = "Breakdown"

# Vehicle parts (AnimationPlayer tracks for specific components)
var door_left: Node3D
var door_right: Node3D
var hood: Node3D
var headlights: Node3D
var smoke_effect: Node3D

# Vehicle state
var is_engine_running: bool = false
var is_door_open: bool = false
var is_hood_open: bool = false
var has_malfunction: bool = false
var malfunction_timer: float = 0.0

# Configuration
@export var malfunction_enabled: bool = true
@export var malfunction_interval: float = 45.0  # Seconds between random malfunctions

# Signals for vehicle system integration
signal door_opened(side: String)
signal door_closed(side: String)
signal hood_opened
signal hood_closed
signal engine_started
signal engine_stopped
signal headlight_malfunction
signal breakdown_triggered

func _ready() -> void:
	super._ready()
	
	# Get references to vehicle parts (assumes scene hierarchy)
	var parent = get_parent()
	if parent:
		door_left = parent.find_child("DoorLeft", true, false)
		door_right = parent.find_child("DoorRight", true, false)
		hood = parent.find_child("Hood", true, false)
		headlights = parent.find_child("Headlights", true, false)
		smoke_effect = parent.find_child("SmokeEffect", true, false)
	
	transition_to(STATE_IDLE)

func _process(delta: float) -> void:
	if not is_ready():
		return
	
	# Track malfunction timer for random vehicle breakdowns
	if malfunction_enabled and is_engine_running:
		malfunction_timer += delta
		if malfunction_timer >= malfunction_interval:
			trigger_random_malfunction()
			malfunction_timer = 0.0

# Start engine with animation/sound
func start_engine() -> void:
	if not is_engine_running:
		is_engine_running = true
		transition_to(STATE_ENGINE_START)
		engine_started.emit()
		
		# Transition to running after startup animation
		await animation_player.animation_finished
		transition_to(STATE_ENGINE_RUNNING)

# Shut down engine
func stop_engine() -> void:
	if is_engine_running:
		is_engine_running = false
		transition_to(STATE_IDLE)
		engine_stopped.emit()

# Open door with animation (left or right)
func open_door(side: String = "left") -> void:
	if is_door_open:
		return
	
	is_door_open = true
	
	# Play specific door animation
	if animation_player:
		var door_anim = "DoorOpen" + side.capitalize()
		if animation_player.has_animation(door_anim):
			animation_player.play(door_anim)
		else:
			animation_player.play(STATE_DOOR_OPEN)
	
	door_opened.emit(side)

# Close door with animation
func close_door(side: String = "left") -> void:
	if not is_door_open:
		return
	
	is_door_open = false
	
	if animation_player:
		var door_anim = "DoorClose" + side.capitalize()
		if animation_player.has_animation(door_anim):
			animation_player.play(door_anim)
		else:
			animation_player.play(STATE_DOOR_CLOSE)
	
	door_closed.emit(side)

# Pop hood animation (engine malfunction effect)
func pop_hood() -> void:
	if not is_hood_open:
		is_hood_open = true
		transition_to(STATE_HOOD_POP)
		hood_opened.emit()

# Close hood animation
func close_hood() -> void:
	if is_hood_open:
		is_hood_open = false
		transition_to(STATE_HOOD_CLOSE)
		hood_closed.emit()

# Headlight flicker animation (malfunction effect)
func flicker_headlights() -> void:
	transition_to(STATE_HEADLIGHT_FLICKER)
	headlight_malfunction.emit()

# Full breakdown sequence - hood pops, lights flicker, smoke appears
func trigger_breakdown() -> void:
	has_malfunction = true
	
	# Sequence of animations
	pop_hood()
	await animation_player.animation_finished
	
	flicker_headlights()
	await animation_player.animation_finished
	
	# Trigger smoke effect if available
	if smoke_effect:
		smoke_effect.show()
		if smoke_effect.has_method("start_smoke"):
			smoke_effect.start_smoke()
	
	breakdown_triggered.emit()

# Random malfunction trigger (called periodically while driving)
func trigger_random_malfunction() -> void:
	if not is_engine_running:
		return
	
	var malfunction_type = randi() % 3
	
	match malfunction_type:
		0:  # Headlight flicker
			flicker_headlights()
		1:  # Hood pop
			if not is_hood_open:
				pop_hood()
		2:  # Full breakdown
			trigger_breakdown()

# Reset vehicle state (after repair)
func repair_vehicle() -> void:
	has_malfunction = false
	
	if is_hood_open:
		close_hood()
	
	if smoke_effect:
		smoke_effect.hide()
	
	malfunction_timer = 0.0
	transition_to(STATE_IDLE if not is_engine_running else STATE_ENGINE_RUNNING)

# Check vehicle health for gameplay logic
func get_malfunction_state() -> bool:
	return has_malfunction
