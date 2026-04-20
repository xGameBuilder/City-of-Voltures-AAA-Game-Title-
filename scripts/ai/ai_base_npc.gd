## Base NPC controller with hierarchical state machine and NavigationAgent3D.
## Manages state transitions, pathfinding, physics, and sensory integration.
class_name AIBaseNPC extends CharacterBody3D

signal state_changed(new_state: String)
signal reached_target
signal lost_target

# State machine
var current_state: AIState
var states: Dictionary[String, AIState] = {}
var state_stack: Array[AIState] = []

# Navigation
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var target_position: Vector3
var path_recalc_timer: float = 0.0
var path_recalc_interval: float = 0.3  # Update path every 0.3s

# Sensory
@onready var sensory: AISensorySystem = $AISensorySystem
var current_target: Node3D = null

# Movement
@export var movement_speed: float = 5.0
@export var rotation_speed: float = 10.0
var velocity: Vector3 = Vector3.ZERO
var desired_velocity: Vector3 = Vector3.ZERO

# Groups and layers
@export var npc_type: String = "generic"  # "turkey", "gang_kid", "civilian"


func _ready() -> void:
	add_to_group("npc")
	
	# Initialize navigation agent
	if nav_agent:
		nav_agent.velocity_computed.connect(_on_velocity_computed)
		nav_agent.target_reached.connect(_on_target_reached)
		call_deferred("setup_navigation")
	
	# Connect sensory signals
	if sensory:
		sensory.target_detected.connect(_on_target_detected)
		sensory.target_lost.connect(_on_target_lost)
	
	# Initialize states from children
	initialize_states()
	
	# Start in first state if available
	if states.size() > 0:
		var first_state_name = states.keys()[0]
		transition_to(first_state_name)


## Initialize states from child nodes
func initialize_states() -> void:
	for child in get_children():
		if child is AIState:
			child.state_machine = self
			states[child.state_name] = child
			child.transitioned.connect(_on_state_transitioned)


## Setup navigation after first physics frame
func setup_navigation() -> void:
	await get_tree().physics_frame
	if nav_agent and is_node_ready():
		nav_agent.path_max_distance = 1.0


func _physics_process(delta: float) -> void:
	# Update physics for current state
	if current_state:
		current_state.physics_update(delta)
	
	# Update navigation
	update_navigation(delta)
	
	# Apply movement
	velocity = move_and_slide(velocity)


func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)


## Transition to a new state
func transition_to(state_name: String, context: Dictionary = {}) -> void:
	if state_name not in states:
		push_error("State '%s' not found in %s" % [state_name, name])
		return
	
	# Exit current state
	if current_state:
		current_state.exit()
	
	# Enter new state
	current_state = states[state_name]
	current_state.enter(context)
	
	state_changed.emit(state_name)


## Push state onto stack (for interruptions like Stun)
func push_state(state_name: String, context: Dictionary = {}) -> void:
	if state_name not in states:
		push_error("State '%s' not found in %s" % [state_name, name])
		return
	
	if current_state:
		current_state.exit()
		state_stack.append(current_state)
	
	current_state = states[state_name]
	current_state.enter(context)


## Pop state from stack (resume previous)
func pop_state() -> void:
	if current_state:
		current_state.exit()
	
	if state_stack.is_empty():
		return
	
	current_state = state_stack.pop_back()
	current_state.enter({})


## Set navigation target
func set_target_position(pos: Vector3) -> void:
	target_position = pos
	if nav_agent:
		nav_agent.target_position = pos


## Update navigation towards target
func update_navigation(delta: float) -> void:
	if not nav_agent or not nav_agent.is_target_reachable():
		desired_velocity = Vector3.ZERO
		return
	
	path_recalc_timer += delta
	if path_recalc_timer >= path_recalc_interval:
		path_recalc_timer = 0.0
		nav_agent.target_position = target_position
	
	if nav_agent.is_navigation_finished():
		desired_velocity = Vector3.ZERO
		reached_target.emit()
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	desired_velocity = direction * movement_speed
	
	# Rotate towards movement direction
	if desired_velocity.length() > 0.1:
		var target_angle = atan2(desired_velocity.x, desired_velocity.z)
		var current_angle = atan2(transform.basis.z.x, transform.basis.z.z)
		var angle_diff = angle_difference(current_angle, target_angle)
		rotate_y(angle_diff * rotation_speed * get_physics_process_delta_time())


## Compute safe velocity for navigation
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity


func _on_target_reached() -> void:
	reached_target.emit()


## Sensory callbacks
func _on_target_detected(target: Node3D) -> void:
	current_target = target


func _on_target_lost(target: Node3D) -> void:
	if current_target == target:
		current_target = null
		lost_target.emit()


func _on_state_transitioned(target_state: String) -> void:
	transition_to(target_state)


## Helper to normalize angle differences
func angle_difference(from: float, to: float) -> float:
	var diff = fmod(to - from, TAU)
	if diff > PI:
		diff -= TAU
	elif diff < -PI:
		diff += TAU
	return diff
