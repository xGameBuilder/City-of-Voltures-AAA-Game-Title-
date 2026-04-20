# Animation controller for environmental animations
# Non-interactive animated elements: traffic lights, signs, decorations
extends Node
class_name EnvironmentAnimationController

# Animation targets
@export var animation_player: AnimationPlayer
@export var traffic_light: Node3D
@export var billboard: Node3D
@export var neon_sign: Node3D
@export var additional_decorations: Array[Node3D]

# Traffic light states
enum LightState { RED, YELLOW, GREEN }
var traffic_light_state: LightState = LightState.RED
var current_light_color: Color = Color.RED

# Billboard rotation
var billboard_enabled: bool = true
var billboard_rotation_speed: float = 0.5  # Rotations per minute

# Neon sign flickering
var neon_flicker_enabled: bool = true
var neon_flicker_intensity: float = 0.3

# Configuration
@export var traffic_light_enabled: bool = true
@export var billboard_rotating: bool = true
@export var neon_flickering: bool = true

# State tracking
var elapsed_time: float = 0.0
var light_cycle_time: float = 30.0  # Seconds for full red->yellow->green->red
var last_light_change: float = 0.0

func _ready() -> void:
	if animation_player:
		animation_player.play("RESET")
	
	start_traffic_light_cycle()

func _process(delta: float) -> void:
	elapsed_time += delta
	
	if traffic_light_enabled:
		update_traffic_light(delta)
	
	if billboard_rotating and billboard:
		update_billboard_rotation(delta)
	
	if neon_flickering and neon_sign:
		update_neon_flicker(delta)
	
	for decoration in additional_decorations:
		if decoration and decoration.has_method("update_animation"):
			decoration.update_animation(delta)

# Update traffic light cycling (red -> yellow -> green -> red)
func update_traffic_light(delta: float) -> void:
	if not traffic_light:
		return
	
	last_light_change += delta
	
	# Calculate which phase of cycle we're in
	var phase_duration = light_cycle_time / 3.0  # 3 phases: red, yellow, green
	var current_phase = int((last_light_change / phase_duration) % 3)
	
	var new_state: LightState
	var new_color: Color
	
	match current_phase:
		0:
			new_state = LightState.RED
			new_color = Color.RED
		1:
			new_state = LightState.YELLOW
			new_color = Color.YELLOW
		2:
			new_state = LightState.GREEN
			new_color = Color.GREEN
		_:
			new_state = LightState.RED
			new_color = Color.RED
	
	# Update traffic light material if present
	if new_state != traffic_light_state:
		traffic_light_state = new_state
		current_light_color = new_color
		update_light_material()

# Update light material color
func update_light_material() -> void:
	if not traffic_light:
		return
	
	# Assume traffic light has a material with emissive color
	var mesh_instance = traffic_light as MeshInstance3D
	if mesh_instance and mesh_instance.get_surface_override_material(0):
		var mat = mesh_instance.get_surface_override_material(0).duplicate()
		mat.emission = current_light_color
		mesh_instance.set_surface_override_material(0, mat)

# Rotate billboard continuously
func update_billboard_rotation(delta: float) -> void:
	if not billboard:
		return
	
	# Calculate rotation angle per frame
	var full_rotation_time = 60.0 / billboard_rotation_speed  # Time for one rotation
	var rotation_amount = (TAU / full_rotation_time) * delta
	
	billboard.rotate_y(rotation_amount)

# Neon sign flicker effect
func update_neon_flicker(delta: float) -> void:
	if not neon_sign:
		return
	
	# Use sine wave for flickering effect
	var flicker_frequency = 3.0  # Hz
	var flicker_value = sin(elapsed_time * flicker_frequency * TAU)
	
	# Map to brightness multiplier (with minimum brightness to keep sign visible)
	var brightness = 1.0 - (abs(flicker_value) * neon_flicker_intensity)
	
	# Update neon material
	var mesh_instance = neon_sign as MeshInstance3D
	if mesh_instance and mesh_instance.get_surface_override_material(0):
		var mat = mesh_instance.get_surface_override_material(0).duplicate()
		mat.emission_energy_multiplier = brightness
		mesh_instance.set_surface_override_material(0, mat)

# Start/stop traffic light cycle
func start_traffic_light_cycle() -> void:
	traffic_light_enabled = true
	last_light_change = 0.0

func stop_traffic_light_cycle() -> void:
	traffic_light_enabled = false

# Start/stop billboard rotation
func start_billboard_rotation() -> void:
	billboard_rotating = true

func stop_billboard_rotation() -> void:
	billboard_rotating = false

# Start/stop neon flicker
func start_neon_flicker() -> void:
	neon_flickering = true

func stop_neon_flicker() -> void:
	neon_flickering = false

# Set traffic light cycle time (in seconds)
func set_light_cycle_time(time: float) -> void:
	light_cycle_time = max(time, 1.0)

# Get current light state (for traffic system integration)
func get_traffic_light_state() -> LightState:
	return traffic_light_state

# Check if pedestrians should be able to cross
func can_pedestrians_cross() -> bool:
	return traffic_light_state == LightState.GREEN
