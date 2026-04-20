# Base animation controller for all animated entities
# Handles common AnimationTree and AnimationPlayer logic
extends Node
class_name BaseAnimationController

@export var animation_tree_path: NodePath
@export var animation_player_path: NodePath
@export var speed_scale: float = 1.0

# References
var animation_tree: AnimationTree
var animation_player: AnimationPlayer
var playback: AnimationNodeStateMachinePlayback

# State tracking
var current_state: String = ""
var is_active: bool = false

# Signals
signal state_changed(old_state: String, new_state: String)
signal animation_finished(animation_name: String)

func _ready() -> void:
	animation_tree = get_node(animation_tree_path) if animation_tree_path else null
	animation_player = get_node(animation_player_path) if animation_player_path else null
	
	if not animation_tree or not animation_player:
		push_error("BaseAnimationController: Missing AnimationTree or AnimationPlayer for ", name)
		return
	
	# Get the playback reference
	playback = animation_tree.get("parameters/playback")
	
	# Activate animation tree
	animation_tree.active = true
	
	# Connect signals
	if animation_player.has_signal("animation_finished"):
		animation_player.animation_finished.connect(_on_animation_finished)
	
	is_active = true

# Transition to a new state
func transition_to(state: String) -> void:
	if not animation_tree or not playback:
		return
	
	if current_state != state:
		var old_state = current_state
		current_state = state
		
		# Use travel for smooth StateMachine transitions
		if playback:
			playback.travel(state)
		
		state_changed.emit(old_state, state)

# Set animation tree parameters for blending (e.g., movement direction)
func set_blend_position(parameter_path: String, value: Vector2) -> void:
	if animation_tree:
		animation_tree.set(parameter_path, value)

func set_blend_position_1d(parameter_path: String, value: float) -> void:
	if animation_tree:
		animation_tree.set(parameter_path, value)

# Play a one-shot animation (for reactions, etc.)
func play_one_shot(animation_name: String) -> void:
	if animation_player:
		animation_player.play(animation_name)

# Control animation playback speed
func set_speed_scale(scale: float) -> void:
	speed_scale = scale
	if animation_player:
		animation_player.speed_scale = scale

# Get current animation playing
func get_current_animation() -> String:
	if animation_player:
		return animation_player.current_animation
	return ""

# Check if animation tree is ready
func is_ready() -> bool:
	return animation_tree != null and animation_player != null and playback != null

func _on_animation_finished(anim_name: String) -> void:
	animation_finished.emit(anim_name)
