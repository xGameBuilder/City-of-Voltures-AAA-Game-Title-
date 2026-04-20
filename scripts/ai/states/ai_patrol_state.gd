## Patrol state - NPC follows predefined waypoints or random walk.
class_name AIPatrolState extends AIState

@export var patrol_waypoints: Array[Vector3] = []  # Can be set via inspector or code
@export var random_walk: bool = false              # If true, walks randomly instead
@export var random_walk_range: float = 30.0        # Range for random walk
@export var waypoint_threshold: float = 2.0        # Distance to consider waypoint reached

var current_waypoint_index: int = 0
var walk_timer: float = 0.0
var walk_change_interval: float = 5.0  # Change target every 5s if random walking


func enter(_context: Dictionary = {}) -> void:
	walk_timer = 0.0
	
	if random_walk:
		pick_random_walk_target()
	elif patrol_waypoints.size() > 0:
		set_waypoint_target(0)


func physics_update(delta: float) -> void:
	walk_timer += delta
	
	# Check for threats
	if state_machine.current_target:
		transition_to("Alert")
		return
	
	# Handle waypoint or random movement
	if random_walk:
		if walk_timer >= walk_change_interval:
			pick_random_walk_target()
			walk_timer = 0.0
	else:
		check_waypoint_progress()


func process(_delta: float) -> void:
	pass


func check_waypoint_progress() -> void:
	if patrol_waypoints.is_empty():
		return
	
	var current_waypoint = patrol_waypoints[current_waypoint_index]
	var distance = state_machine.global_position.distance_to(current_waypoint)
	
	if distance < waypoint_threshold:
		current_waypoint_index = (current_waypoint_index + 1) % patrol_waypoints.size()
		set_waypoint_target(current_waypoint_index)


func set_waypoint_target(index: int) -> void:
	if index < patrol_waypoints.size():
		state_machine.set_target_position(patrol_waypoints[index])


func pick_random_walk_target() -> void:
	var random_offset = Vector3(
		randf_range(-random_walk_range, random_walk_range),
		0,
		randf_range(-random_walk_range, random_walk_range)
	)
	var target = state_machine.global_position + random_offset
	state_machine.set_target_position(target)


func exit() -> void:
	pass
