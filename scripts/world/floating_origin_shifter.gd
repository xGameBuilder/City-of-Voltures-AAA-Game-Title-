## Floating Origin Shifter - Prevents floating-point precision issues at large distances
class_name FloatingOriginShifter
extends Node

@export var threshold_distance: float = 8000.0  # Shift when player exceeds this distance from origin
@export var shift_step: float = 5000.0         # How much to shift the world

var player: Node3D
var world_origin: Vector3 = Vector3.ZERO

func _ready() -> void:
	player = get_tree().root.get_child(0).find_child("PlayerController", true, false)
	if not player:
		push_error("FloatingOriginShifter: Player not found")

func _process(delta: float) -> void:
	if not player:
		return
	
	var player_distance = player.global_position.distance_to(world_origin)
	
	if player_distance > threshold_distance:
		shift_world()

func shift_world() -> void:
	var shift_vector = player.global_position - world_origin
	shift_vector.y = 0  # Keep Y at origin level
	
	# Shift all movable objects
	shift_all_nodes(shift_vector)
	
	# Update world origin
	world_origin += shift_vector
	
	print("Shifted world origin by: ", shift_vector)

func shift_all_nodes(shift: Vector3) -> void:
	# Shift player back to near origin
	player.global_position -= shift
	
	# Shift all chunks (assuming they are children of WorldStreamer)
	var world_streamer = get_parent()
	if world_streamer and world_streamer is WorldStreamer:
		for chunk in world_streamer.active_chunks.values():
			if chunk:
				chunk.global_position -= shift
	
	# Shift other world objects (POIs, NPCs, etc.)
	var root = get_tree().root
	shift_node_recursive(root, shift)

func shift_node_recursive(node: Node, shift: Vector3) -> void:
	if node is Node3D and node != player:
		# Only shift if not already shifted (avoid double-shifting)
		if not node.is_in_group("no_shift"):
			node.global_position -= shift
	
	for child in node.get_children():
		shift_node_recursive(child, shift)