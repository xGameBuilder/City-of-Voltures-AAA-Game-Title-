# Animation controller for NPC humanoid characters
# Supports patrol, combat, alert, flee, and death animations
extends BaseAnimationController
class_name NPCAnimationController

# Animation states
const STATE_IDLE = "Idle"
const STATE_PATROL_WALK = "PatrolWalk"
const STATE_COMBAT_IDLE = "CombatIdle"
const STATE_ALERT = "Alert"
const STATE_FLEE = "Flee"
const STATE_ATTACK = "Attack"
const STATE_HIT = "Hit"
const STATE_DEATH = "Death"

# Blend space parameter paths (if using locomotion blending)
const MOVEMENT_BLEND_PATH = "parameters/Movement/blend_position"

# References
@export var character_body: CharacterBody3D
@export var ai_controller: Node  # Reference to NPC AI controller

# State variables
var is_patrolling: bool = false
var is_in_combat: bool = false
var is_alerted: bool = false
var is_fleeing: bool = false
var patrol_target: Vector3 = Vector3.ZERO
var current_velocity: Vector3 = Vector3.ZERO
var movement_speed: float = 0.0

# Animation parameters
var patrol_speed: float = 2.0
var combat_speed: float = 4.0
var flee_speed: float = 6.0

# Signals for AI coordination
signal state_transitioned(new_state: String)
signal animation_started(animation_name: String)
signal animation_ended(animation_name: String)

func _ready() -> void:
	super._ready()
	
	if not character_body:
		character_body = get_parent()
	
	transition_to(STATE_IDLE)

func _process(_delta: float) -> void:
	if not is_ready():
		return
	
	# Update blend position for movement
	update_movement_blend()

# Update movement blend for locomotion animations
func update_movement_blend() -> void:
	if not character_body or not animation_tree:
		return
	
	var horizontal_velocity = Vector3(character_body.velocity.x, 0, character_body.velocity.z)
	movement_speed = horizontal_velocity.length()
	
	# Calculate blend position
	if character_body.get_parent() is Node3D:
		var local_velocity = character_body.get_global_basis().inverse() * horizontal_velocity
		var max_blend_speed = 6.0
		var blend_x = clamp(local_velocity.x / max_blend_speed, -1.0, 1.0)
		var blend_y = clamp(local_velocity.z / max_blend_speed, -1.0, 1.0)
		
		var current_blend = animation_tree.get(MOVEMENT_BLEND_PATH)
		if current_blend is Vector2:
			var smoothed = current_blend.lerp(Vector2(blend_x, blend_y), 0.12)
			set_blend_position(MOVEMENT_BLEND_PATH, smoothed)

# Start patrol behavior with walk animation
func start_patrol() -> void:
	is_patrolling = true
	is_in_combat = false
	is_alerted = false
	is_fleeing = false
	
	transition_to(STATE_PATROL_WALK)
	state_transitioned.emit(STATE_PATROL_WALK)

# Enter combat stance
func enter_combat() -> void:
	is_in_combat = true
	is_patrolling = false
	is_fleeing = false
	
	transition_to(STATE_COMBAT_IDLE)
	state_transitioned.emit(STATE_COMBAT_IDLE)

# Alert reaction (notice player/threat)
func play_alert_reaction() -> void:
	is_alerted = true
	transition_to(STATE_ALERT)
	state_transitioned.emit(STATE_ALERT)
	
	# After alert animation, transition to appropriate state
	await animation_player.animation_finished
	
	if is_fleeing:
		play_flee()
	elif is_in_combat:
		enter_combat()

# Play flee animation
func play_flee() -> void:
	is_fleeing = true
	is_in_combat = false
	
	transition_to(STATE_FLEE)
	state_transitioned.emit(STATE_FLEE)

# Play attack animation
func play_attack() -> void:
	if not is_in_combat:
		enter_combat()
	
	transition_to(STATE_ATTACK)
	state_transitioned.emit(STATE_ATTACK)

# Play hit/damage reaction
func play_hit_reaction() -> void:
	transition_to(STATE_HIT)

# Play death animation with ragdoll
func play_death_ragdoll() -> void:
	is_in_combat = false
	is_patrolling = false
	is_fleeing = false
	
	transition_to(STATE_DEATH)
	set_speed_scale(1.0)
	
	# Optional: transition to ragdoll physics after animation
	await animation_player.animation_finished
	enable_ragdoll()

# Enable ragdoll physics simulation
func enable_ragdoll() -> void:
	if animation_tree:
		animation_tree.active = false
	
	# Signal that ragdoll physics should take over
	if character_body:
		character_body.active = true  # Enable physics

# Return to idle state
func return_to_idle() -> void:
	is_patrolling = false
	is_in_combat = false
	is_alerted = false
	is_fleeing = false
	
	transition_to(STATE_IDLE)
	state_transitioned.emit(STATE_IDLE)

# Get NPC current activity state for AI logic
func get_activity_state() -> String:
	if is_fleeing:
		return "flee"
	elif is_in_combat:
		return "combat"
	elif is_patrolling:
		return "patrol"
	elif is_alerted:
		return "alert"
	else:
		return "idle"
