## World Streamer - Manages chunk-based loading/unloading for open world
class_name WorldStreamer
extends Node3D

@export var chunk_size: float = 500.0  # Size of each chunk (500m x 500m)
@export var render_distance: int = 3   # Load chunks within 3 radius
@export var unload_distance: int = 5   # Unload chunks beyond 5 radius

var player: Node3D
var active_chunks: Dictionary = {}  # Vector2i -> Node3D (chunk reference)
var loading_queue: Array[Vector2i] = []
var unloading_queue: Array[Vector2i] = []

## Chunk prefab paths indexed by district
var chunk_prefabs: Dictionary = {
	"trenches": "res://scenes/districts/trenches/chunk.tscn",
	"snob40s": "res://scenes/districts/snob40s/chunk.tscn",
	"pocket_burb": "res://scenes/districts/pocket_burb/chunk.tscn",
	"rincon": "res://scenes/districts/rincon/chunk.tscn",
}

func _ready() -> void:
	player = get_tree().root.get_child(0).find_child("PlayerController", true, false)
	if not player:
		push_error("WorldStreamer: Player not found")
		return
	
	# Load initial chunks
	update_chunks()

func _process(delta: float) -> void:
	if not player:
		return
	
	update_chunks()

func update_chunks() -> void:
	var player_chunk = world_to_chunk(player.global_position)
	
	# Determine needed chunks within render distance
	var needed_chunks: Array[Vector2i] = []
	for x in range(-render_distance, render_distance + 1):
		for z in range(-render_distance, render_distance + 1):
			needed_chunks.append(player_chunk + Vector2i(x, z))
	
	# Unload chunks outside render distance
	for chunk_coord in active_chunks.keys():
		if chunk_coord not in needed_chunks:
			if chunk_coord not in unloading_queue:
				unloading_queue.append(chunk_coord)
	
	# Load new chunks
	for chunk_coord in needed_chunks:
		if chunk_coord not in active_chunks and chunk_coord not in loading_queue:
			loading_queue.append(chunk_coord)
	
	# Process queues
	process_unloading()
	process_loading()

func process_loading() -> void:
	if loading_queue.is_empty():
		return
	
	var chunk_coord = loading_queue.pop_front()
	var district = get_district_for_chunk(chunk_coord)
	
	if district == "":
		return
	
	# Load chunk asynchronously
	load_chunk_async(chunk_coord, district)

func load_chunk_async(chunk_coord: Vector2i, district: String) -> void:
	var chunk_path = chunk_prefabs.get(district)
	if not chunk_path:
		push_error("Unknown district: ", district)
		return
	
	# For now, load synchronously (in production, use ResourceLoader.load_threaded_request)
	var chunk_scene = load(chunk_path)
	if chunk_scene:
		var chunk_instance = chunk_scene.instantiate()
		chunk_instance.global_position = chunk_to_world(chunk_coord)
		chunk_instance.name = "Chunk_%d_%d" % [chunk_coord.x, chunk_coord.y]
		add_child(chunk_instance)
		active_chunks[chunk_coord] = chunk_instance
		print("Loaded chunk: ", chunk_instance.name)

func process_unloading() -> void:
	while not unloading_queue.is_empty():
		var chunk_coord = unloading_queue.pop_front()
		if chunk_coord in active_chunks:
			var chunk = active_chunks[chunk_coord]
			chunk.queue_free()
			active_chunks.erase(chunk_coord)
			print("Unloaded chunk: Chunk_%d_%d" % [chunk_coord.x, chunk_coord.y])

func world_to_chunk(world_pos: Vector3) -> Vector2i:
	return Vector2i(
		int(world_pos.x / chunk_size),
		int(world_pos.z / chunk_size)
	)

func chunk_to_world(chunk_coord: Vector2i) -> Vector3:
	return Vector3(
		chunk_coord.x * chunk_size,
		0.0,
		chunk_coord.y * chunk_size
	)

func get_district_for_chunk(chunk_coord: Vector2i) -> String:
	# Simple district mapping based on chunk coordinates
	# This can be expanded with a more complex zoning system
	var chunk_dist = chunk_coord.length()
	
	if chunk_coord.x < -2 and chunk_coord.y < -2:
		return "trenches"
	elif chunk_coord.x > 2 and chunk_coord.y > 2:
		return "snob40s"
	elif chunk_coord.x < -2 and chunk_coord.y > 2:
		return "pocket_burb"
	elif chunk_coord.x > -2 and chunk_coord.x < 2 and chunk_coord.y < 2:
		return "rincon"
	
	return ""

func get_active_chunk_count() -> int:
	return active_chunks.size()
