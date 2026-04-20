## Sensory system for NPC vision, sound, and line-of-sight detection.
## Detects enemies via vision cones, sound sources, and validates LOS to targets.
class_name AISensorySystem extends Node3D

signal target_detected(target: Node3D)
signal target_lost(target: Node3D)
signal sound_detected(source: Vector3, intensity: float)

@export var vision_range: float = 50.0      # How far NPC can see
@export var vision_angle: float = 60.0      # Horizontal FOV in degrees
@export var hearing_range: float = 80.0     # How far NPC can hear
@export var check_line_of_sight: bool = true  # Validate visual targets via raycasts
@export var update_interval: float = 0.2    # How often to update senses (20 checks/sec)

var npc: AIBaseNPC
var current_target: Node3D
var targets_in_range: Array[Node3D] = []
var update_timer: float = 0.0
var space_state: PhysicsDirectSpaceState3D

func _ready() -> void:
	npc = get_parent() as AIBaseNPC
	space_state = get_world_3d().direct_space_state


func _process(delta: float) -> void:
	update_timer += delta
	
	if update_timer >= update_interval:
		update_timer = 0.0
		sense_vision()
		sense_hearing()


## Check for targets in a vision cone
func sense_vision() -> void:
	if not npc:
		return
	
	targets_in_range.clear()
	var npc_pos = global_position
	var npc_forward = -global_transform.basis.z  # Forward in Godot 3D
	var vision_angle_rad = deg_to_rad(vision_angle / 2.0)
	
	# Query all bodies in range
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = SphereShape3D.new()
	query.shape.radius = vision_range
	query.transform = global_transform
	query.collision_mask = 1  # Adjust to target layer
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var body = result["collider"]
		
		# Filter: Skip self, skip non-targets
		if body == npc or body == npc.get_parent():
			continue
		
		if not is_valid_target(body):
			continue
		
		# Check angle: Is target within vision cone?
		var to_target = (body.global_position - npc_pos).normalized()
		var dot = npc_forward.dot(to_target)
		
		if dot < cos(vision_angle_rad):
			continue  # Outside cone
		
		# Check LOS if enabled
		if check_line_of_sight:
			if not has_line_of_sight(npc_pos, body.global_position):
				continue
		
		targets_in_range.append(body)
		
		if current_target != body:
			current_target = body
			target_detected.emit(body)


## Check for sound sources (e.g., Karen Rage)
func sense_hearing() -> void:
	# Listen for sound events via signals or groups
	# For now, this is a placeholder for integration with Karen Rage
	pass


## Validate line-of-sight via raycast
func has_line_of_sight(from: Vector3, to: Vector3) -> bool:
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	# If hit nothing, we have LOS. If hit something, check if it's the target
	if result.is_empty():
		return true
	
	# Check if raycast hit the target or nothing blocking
	return result.get("collider") != null


## Check if a body is a valid target (e.g., Player or other NPC)
func is_valid_target(body: Node) -> bool:
	# Override in subclasses or check via groups
	return body.is_in_group("player") or body.is_in_group("npc")


## Get the closest target in range
func get_closest_target() -> Node3D:
	if targets_in_range.is_empty():
		return null
	
	var closest = targets_in_range[0]
	var closest_dist = global_position.distance_to(closest.global_position)
	
	for target in targets_in_range:
		var dist = global_position.distance_to(target.global_position)
		if dist < closest_dist:
			closest = target
			closest_dist = dist
	
	return closest


## Called by other systems to trigger auditory alert
func alert_sound(source: Vector3, intensity: float = 1.0) -> void:
	var dist = global_position.distance_to(source)
	if dist <= hearing_range * intensity:
		sound_detected.emit(source, intensity)
		if not current_target:
			current_target = null  # You can set to sound source location
