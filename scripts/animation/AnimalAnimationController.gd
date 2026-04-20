# Animation controller for animals (Feral Turkeys, etc.)
# Handles animal-specific animations: walk, charge, hit, death
extends BaseAnimationController
class_name AnimalAnimationController

# Animation states
const STATE_IDLE = "Idle"
const STATE_WALK = "Walk"
const STATE_CHARGE_ATTACK = "ChargeAttack"
const STATE_PECK_ATTACK = "PeckAttack"
const STATE_HIT_REACTION = "HitReaction"
const STATE_DEATH = "Death"
const STATE_FLEE = "Flee"

# Blend space path
const MOVEMENT_BLEND_PATH = "parameters/Movement/blend_position"

# References
@export var character_body: CharacterBody3D
@export var animal_type: String = "turkey"  # turkey, dog, etc.

# State tracking
var is_attacking: bool = false
var is_charging: bool = false
var current_velocity: Vector3 = Vector3.ZERO
var movement_speed: float = 0.0

# Animal-specific stats
var walk_speed: float = 3.0
var charge_speed: float = 8.0
var turn_speed: float = 3.0

# Signals
signal attacked
signal hit
signal died

func _ready() -> void:
	super._ready()
	
	if not character_body:
		character_body = get_parent()
	
	transition_to(STATE_IDLE)

func _process(_delta: float) -> void:
	if not is_ready():
		return
	
	update_movement_blend()

# Update locomotion blending based on movement
func update_movement_blend() -> void:
	if not character_body or not animation_tree:
		return
	
	var horizontal_velocity = Vector3(character_body.velocity.x, 0, character_body.velocity.z)
	movement_speed = horizontal_velocity.length()
	
	# Calculate blend for directional movement
	if movement_speed > 0.1:
		var direction = horizontal_velocity.normalized()
		var blend_x = clamp(direction.x, -1.0, 1.0)
		var blend_y = clamp(direction.z, -1.0, 1.0)
		
		var current_blend = animation_tree.get(MOVEMENT_BLEND_PATH)
		if current_blend is Vector2:
			var smoothed = current_blend.lerp(Vector2(blend_x, blend_y), 0.15)
			set_blend_position(MOVEMENT_BLEND_PATH, smoothed)
	else:
		# Idle blending
		var current_blend = animation_tree.get(MOVEMENT_BLEND_PATH)
		if current_blend is Vector2:
			var smoothed = current_blend.lerp(Vector2.ZERO, 0.1)
			set_blend_position(MOVEMENT_BLEND_PATH, smoothed)

# Start roaming/walking behavior
func start_walk() -> void:
	if current_state != STATE_WALK:
		transition_to(STATE_WALK)

# Prepare and execute charge attack (turkeys rushing player)
func start_charge_attack() -> void:
	is_charging = true
	is_attacking = true
	transition_to(STATE_CHARGE_ATTACK)
	attacked.emit()

# Quick peck attack animation
func play_peck_attack() -> void:
	is_attacking = true
	transition_to(STATE_PECK_ATTACK)
	attacked.emit()
	
	await animation_player.animation_finished
	is_attacking = false

# Hit reaction (when animal takes damage)
func play_hit_reaction() -> void:
	transition_to(STATE_HIT_REACTION)
	hit.emit()

# Death animation
func play_death() -> void:
	is_attacking = false
	is_charging = false
	transition_to(STATE_DEATH)
	set_speed_scale(1.0)
	died.emit()
	
	await animation_player.animation_finished
	# Optional ragdoll transition
	enable_ragdoll()

# Enable ragdoll physics
func enable_ragdoll() -> void:
	if animation_tree:
		animation_tree.active = false

# Return to idle or walking
func return_to_idle() -> void:
	is_attacking = false
	is_charging = false
	transition_to(STATE_IDLE)

# Flee animation (when threatened by player)
func play_flee() -> void:
	is_attacking = false
	transition_to(STATE_FLEE)

# Get current activity for AI logic
func get_activity() -> String:
	if is_attacking:
		return "attacking"
	elif current_state == STATE_WALK:
		return "walking"
	elif current_state == STATE_FLEE:
		return "fleeing"
	else:
		return "idle"

# Specific to turkeys: gobble sound trigger (synchronized with animation)
func trigger_gobble_sound() -> void:
	if animation_player and animal_type == "turkey":
		# Play sound effect via animation track or code
		pass

# Get movement speed ratio for procedural animations
func get_speed_ratio() -> float:
	return movement_speed / charge_speed
