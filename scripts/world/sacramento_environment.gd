## World Environment Setup - Sacramento climate and atmosphere
class_name SacramentoEnvironment
extends WorldEnvironment

## Time of day cycle
@export var time_of_day: float = 12.0  # 0-24 hours
@export var time_speed: float = 0.01   # Multiplier for time progression

## Seasonal parameters
@export var season: String = "summer"  # summer, spring, winter, fall
@export var enable_time_cycle: bool = true

var sky_material: ProceduralSkyMaterial
var env: Environment
var main_light: DirectionalLight3D

func _ready() -> void:
	if not environment:
		environment = Environment.new()
	
	env = environment
	setup_procedural_sky()
	setup_lighting()
	setup_atmosphere()

func _process(delta: float) -> void:
	if enable_time_cycle:
		update_time_of_day(delta)
		update_lighting()

## Setup ProceduralSkyMaterial for Sacramento heat haze
func setup_procedural_sky() -> void:
	sky_material = ProceduralSkyMaterial.new()
	
	# Sacramento summer heat: hazy yellow/orange sky
	match season:
		"summer":
			sky_material.sky_top_color = Color(1.0, 0.85, 0.6, 1.0)  # Hazy yellow-orange
			sky_material.sky_horizon_color = Color(1.0, 0.8, 0.5, 1.0)
			sky_material.ground_horizon_color = Color(0.9, 0.75, 0.4, 1.0)
		"spring":
			sky_material.sky_top_color = Color(0.8, 0.9, 1.0, 1.0)  # Clear blue
			sky_material.sky_horizon_color = Color(1.0, 0.9, 0.8, 1.0)
			sky_material.ground_horizon_color = Color(0.8, 0.8, 0.7, 1.0)
		"winter":
			sky_material.sky_top_color = Color(0.7, 0.8, 0.9, 1.0)  # Overcast
			sky_material.sky_horizon_color = Color(0.85, 0.85, 0.9, 1.0)
			sky_material.ground_horizon_color = Color(0.6, 0.6, 0.7, 1.0)
		"fall":
			sky_material.sky_top_color = Color(0.9, 0.8, 0.7, 1.0)  # Golden hour
			sky_material.sky_horizon_color = Color(1.0, 0.85, 0.6, 1.0)
			sky_material.ground_horizon_color = Color(0.8, 0.7, 0.5, 1.0)
	
	sky_material.sun_disk_scale = 1.5
	sky_material.sun_angle_max = 100.0
	
	var sky = Sky.new()
	sky.sky_material = sky_material
	env.sky = sky

## Setup DirectionalLight for sun position
func setup_lighting() -> void:
	if main_light == null:
		main_light = DirectionalLight3D.new()
		add_child(main_light)
		main_light.owner = get_tree().edited_scene_root
	
	main_light.shadows_enabled = true
	main_light.shadow_blur = 1
	main_light.directional_shadow_mode = DirectionalLight3D.SHADOW_CASCADED_4_SPLITS
	main_light.directional_shadow_split_1 = 0.1
	main_light.directional_shadow_split_2 = 0.3
	main_light.directional_shadow_split_3 = 0.7

## Atmospheric effects: fog, ambient light, etc.
func setup_atmosphere() -> void:
	env.ambient_light_source = Environment.AMBIENT_LIGHT_DISABLED
	env.ambient_light_energy = 0.5
	
	# Adjust for season
	match season:
		"summer":
			env.ambient_light_energy = 1.2  # Brighter
			env.fog_enabled = true
			env.fog_air_density = 0.01  # Light heat haze
		"spring":
			env.ambient_light_energy = 1.0
			env.fog_enabled = false
		"winter":
			env.ambient_light_energy = 0.8
			env.fog_enabled = true
			env.fog_air_density = 0.005
		"fall":
			env.ambient_light_energy = 1.0
			env.fog_enabled = true
			env.fog_air_density = 0.003

## Update sun position based on time of day
func update_time_of_day(delta: float) -> void:
	time_of_day += delta * time_speed
	if time_of_day >= 24.0:
		time_of_day -= 24.0
	
	# Sun angle: 0 = sunrise, 12 = zenith, 18 = sunset
	var sun_angle = (time_of_day - 6.0) / 12.0 * 180.0  # 6am to 6pm = 0 to 180 degrees
	sun_angle = clamp(sun_angle, 0, 180)
	
	if main_light:
		main_light.rotation.x = deg_to_rad(-sun_angle + 90)

## Update lighting based on time
func update_lighting() -> void:
	var brightness = calculate_brightness()
	
	if main_light:
		main_light.light_energy = brightness
	
	env.ambient_light_energy = brightness * 0.5

func calculate_brightness() -> float:
	# Brightness peaks at noon (12), low at dawn/dusk
	var noon_offset = abs(time_of_day - 12.0)
	if noon_offset < 6.0:
		return 1.0 - (noon_offset / 6.0) * 0.3  # 0.7 to 1.0
	else:
		if time_of_day < 6.0 or time_of_day > 18.0:
			return 0.2  # Night time
		else:
			return 0.7
	return 0.7

func set_season(new_season: String) -> void:
	season = new_season
	setup_procedural_sky()
	setup_atmosphere()

func get_current_time() -> String:
	var hours = int(time_of_day)
	var minutes = int((time_of_day - hours) * 60)
	return "%02d:%02d" % [hours, minutes]
