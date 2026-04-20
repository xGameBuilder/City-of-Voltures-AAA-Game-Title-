## POI Manager - Tracks discovery, visibility, and compass updates
class_name POIManager
extends Node

signal poi_discovered(poi: POIMarker)
signal poi_lost_sight(poi: POIMarker)

@export var discovery_range: float = 100.0
@export var visibility_range: float = 200.0

var poi_database: Dictionary = {}  # poi_id -> POIMarker
var visible_pois: Array[POIMarker] = []
var discovered_pois: Array[POIMarker] = []

var player: Node3D

func _ready() -> void:
	player = get_tree().root.get_child(0).find_child("PlayerController", true, false)
	if not player:
		push_warning("POIManager: Player not found")

func _process(delta: float) -> void:
	if not player:
		return
	
	update_poi_visibility()
	update_poi_discovery()

func register_poi(poi: POIMarker) -> void:
	poi_database[poi.poi_id] = poi

func update_poi_visibility() -> void:
	visible_pois.clear()
	for poi in poi_database.values():
		if not poi.is_active:
			continue
		
		var distance = player.global_position.distance_to(poi.position_world)
		if distance <= visibility_range:
			visible_pois.append(poi)

func update_poi_discovery() -> void:
	for poi in poi_database.values():
		if poi.is_discovered:
			continue
		
		var distance = player.global_position.distance_to(poi.position_world)
		if distance <= discovery_range:
			poi.is_discovered = true
			discovered_pois.append(poi)
			poi_discovered.emit(poi)
			print("Discovered POI: ", poi.poi_name)

## Get POIs sorted by angle from player forward direction (for compass)
func get_compass_pois() -> Array[POIMarker]:
	if not player:
		return []
	
	var sorted_pois = visible_pois.duplicate()
	sorted_pois.sort_custom(func(a: POIMarker, b: POIMarker) -> bool:
		var angle_a = get_angle_to_poi(a)
		var angle_b = get_angle_to_poi(b)
		return angle_a < angle_b
	)
	return sorted_pois

func get_angle_to_poi(poi: POIMarker) -> float:
	var player_forward = player.global_transform.basis.z  # Forward direction
	var to_poi = (poi.position_world - player.global_position).normalized()
	return player_forward.signed_angle_to(to_poi, Vector3.UP)

func get_poi_by_id(poi_id: String) -> POIMarker:
	return poi_database.get(poi_id)

func get_nearest_poi() -> POIMarker:
	if visible_pois.is_empty():
		return null
	
	var nearest = visible_pois[0]
	var min_dist = player.global_position.distance_to(nearest.position_world)
	
	for poi in visible_pois:
		var dist = player.global_position.distance_to(poi.position_world)
		if dist < min_dist:
			min_dist = dist
			nearest = poi
	
	return nearest
