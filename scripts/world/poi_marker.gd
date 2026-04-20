## POI (Point of Interest) Marker Resource
## Defines landmarks, quests, and discovery points in Sacramento
class_name POIMarker
extends Resource

@export var poi_id: String = ""
@export var poi_name: String = ""
@export var poi_type: String = "landmark"  # landmark, quest, entity, hazard
@export var position_world: Vector3 = Vector3.ZERO
@export var description: String = ""
@export var icon: Texture2D

## Discovery flags
@export var is_discovered: bool = false
@export var is_active: bool = true

## Optional linked data
@export var linked_quest_id: String = ""
@export var linked_npc_id: String = ""

## Compass/HUD data
@export var compass_icon: Texture2D
@export var marker_color: Color = Color.WHITE
@export var priority: int = 0  # Higher = more visible on compass

func _init(p_id: String = "", p_name: String = "", p_type: String = "landmark", p_pos: Vector3 = Vector3.ZERO) -> void:
	poi_id = p_id
	poi_name = p_name
	poi_type = p_type
	position_world = p_pos
