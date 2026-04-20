## Environmental Hazards - Potholes, broken roads, debris
class_name EnvironmentalHazard
extends Area3D

enum HazardType { POTHOLE, BROKEN_ROAD, DEBRIS, RUBBLE, SPIKES }

@export var hazard_type: HazardType = HazardType.POTHOLE
@export var damage_amount: float = 5.0
@export var slowdown_factor: float = 0.5  # 0.5 = 50% speed reduction
@export var vehicle_only: bool = true
@export var hazard_name: String = "Pothole"

var affected_bodies: Array[Node3D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Visual feedback based on hazard type
	var mesh_inst = MeshInstance3D.new()
	match hazard_type:
		HazardType.POTHOLE:
			var box = BoxMesh.new()
			box.size = Vector3(2.0, 0.5, 2.0)
			mesh_inst.mesh = box
		HazardType.BROKEN_ROAD:
			var box = BoxMesh.new()
			box.size = Vector3(4.0, 0.3, 4.0)
			mesh_inst.mesh = box
		HazardType.DEBRIS:
			var sphere = SphereMesh.new()
			sphere.radial_segments = 8
			sphere.rings = 4
			mesh_inst.mesh = sphere
	
	mesh_inst.set_surface_override_material(0, create_hazard_material())
	add_child(mesh_inst)

func create_hazard_material() -> Material:
	var mat = StandardMaterial3D.new()
	match hazard_type:
		HazardType.POTHOLE:
			mat.albedo_color = Color(0.2, 0.2, 0.2, 1.0)
		HazardType.BROKEN_ROAD:
			mat.albedo_color = Color(0.3, 0.25, 0.2, 1.0)
		HazardType.DEBRIS:
			mat.albedo_color = Color(0.5, 0.4, 0.3, 1.0)
		HazardType.SPIKES:
			mat.albedo_color = Color(0.8, 0.1, 0.1, 1.0)
	return mat

func _on_area_entered(area: Area3D) -> void:
	if vehicle_only and not area.is_in_group("vehicles"):
		return
	
	if area not in affected_bodies:
		affected_bodies.append(area)
		apply_hazard_effect(area)

func _on_area_exited(area: Area3D) -> void:
	if area in affected_bodies:
		affected_bodies.erase(area)

func apply_hazard_effect(target: Area3D) -> void:
	# Emit signal so vehicle controller can react
	target.emit_signal("hazard_hit", self)
	print("Hazard hit: ", hazard_name, " on ", target.name)
