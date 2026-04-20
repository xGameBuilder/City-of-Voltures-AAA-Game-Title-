# Animation controller for Chet Miller (Player Character)
# Handles locomotion blending, combat poses, and special states
extends BaseAnimationController
class_name ChetAnimationController

# Blend space parameter paths
const MOVEMENT_BLEND_PATH = "parameters/Movement/blend_position"
const MOVEMENT_STATE_PATH = "parameters/StateMachine/transition_request"

# Animation states
const STATE_IDLE = "Idle"
const STATE_WALK = "Walk"
const STATE_RUN = "Run"
const STATE_JUMP = "Jump"
const STATE_LAND = "Land"
const STATE_KAREN_RAGE = "KarenRage"
const STATE_INTERACT = "Interact"
const STATE_DEATH = "Death"

# References to movement and action systems
@export var character_body: CharacterBody3D
@export var karen_rage_ref: Node  # KarenRage system

# Movement tracking for locomotion blending
var current_velocity: Vector3 = Vector3.ZERO
var target_blend_position: Vector2 = Vector2.ZERO
var camera_basis: Basis = Basis.IDENTITY

# Animation blend parameters
var movement_speed: float = 0.0
var walk_speed: float = 5.0
var run_speed: float = 10.0
var max_speed: float = 10.0

# State flags
var is_jumping: bool = false
var is_moving: bool = false
var is_sprinting: bool = false
var in_karen_rage: bool = false

func _ready() -> void:
	super._ready()
	
	if not character_body:
		character_body = get_parent()
	
	if not animation_player:
		return
	
	# Set initial state
	transition_to(STATE_IDLE)

func _process(_delta: float) -> void:
	if not is_ready():
		return
	
	# Update blend position for locomotion based on input
	update_movement_blend()

# Update movement blending based on character velocity and movement direction
func update_movement_blend() -> void:
	if not character_body:
		return
	
	# Calculate movement speed from character body velocity
	var horizontal_velocity = Vector3(character_body.velocity.x, 0, character_body.velocity.z)
	movement_speed = horizontal_velocity.length()
	
	# Determine if moving and current direction
	is_moving = movement_speed > 0.1
	
	# Calculate blend position for directional locomotion
	# X-axis: left/right strafe, Y-axis: forward/backward
	var local_velocity = horizontal_velocity
	if character_body.get_parent() is Node3D:
		local_velocity = character_body.get_global_basis().inverse() * horizontal_velocity
	
	# Normalize to blend space (typically 0-1 range)
	if max_speed > 0:
		var blend_x = clamp(local_velocity.x / max_speed, -1.0, 1.0)
		var blend_y = clamp(local_velocity.z / max_speed, -1.0, 1.0)
		target_blend_position = Vector2(blend_x, blend_y)
	
	# Smoothly interpolate blend position
	var current_blend = animation_tree.get(MOVEMENT_BLEND_PATH)
	if current_blend is Vector2:
		var smoothed_blend = current_blend.lerp(target_blend_position, 0.1)
		set_blend_position(MOVEMENT_BLEND_PATH, smoothed_blend)
	
	# Update animation state based on movement
	update_locomotion_state()

# Update locomotion state based on movement speed
func update_locomotion_state() -> void:
	if in_karen_rage:
		return
	
	# Determine next state based on speed
	var next_state = STATE_IDLE
	
	if is_jumping:
		next_state = STATE_JUMP
	elif is_moving:
		if is_sprinting or movement_speed > run_speed * 0.8:
			next_state = STATE_RUN
		else:
			next_state = STATE_WALK
	else:
		# Idle or landing
		if character_body.is_on_floor():
			next_state = STATE_IDLE
		else:
			next_state = STATE_JUMP
	
	if current_state != next_state:
		transition_to(next_state)

# Called by character controller when jumping
func on_jump_started() -> void:
	is_jumping = true
	transition_to(STATE_JUMP)

# Called by character controller when landed
func on_landed() -> void:
	is_jumping = false
	transition_to(STATE_LAND)

# Called when sprinting starts/stops
func set_sprinting(sprinting: bool) -> void:
	is_sprinting = sprinting
	if is_sprinting:
		max_speed = run_speed
	else:
		max_speed = walk_speed

# Karen Rage activation - switch to power stance animation
func activate_karen_rage() -> void:
	in_karen_rage = true
	transition_to(STATE_KAREN_RAGE)

# Karen Rage deactivation - return to normal
func deactivate_karen_rage() -> void:
	in_karen_rage = false
	transition_to(STATE_IDLE)

# Interact animation (triggering NPC dialogue)
func play_interact() -> void:
	transition_to(STATE_INTERACT)

# Death animation
func play_death() -> void:
	transition_to(STATE_DEATH)
	set_speed_scale(1.0)

# Ragdoll transition (physical simulation)
func enable_ragdoll() -> void:
	# Disable animation tree and switch to physics-based ragdoll
	if animation_tree:
		animation_tree.active = false
	play_death()

# Get current movement state for debugging/UI
func get_locomotion_state() -> String:
	return current_state

# Get normalized movement speed for UI indicators
func get_speed_ratio() -> float:
	return movement_speed / max_speed
