extends Node
## AmbientSFXManager - Manages environmental ambient sounds: traffic, sirens, construction, wildlife
## Uses looping streams for continuous environmental background

class_name AmbientSFXManager

# Ambient soundscapes
var ambient_loops: Dictionary = {
	"busy_street": {
		"path": "res://assets/audio/sfx/ambient/busy_street_loop.ogg",
		"volume_db": -15.0,
		"context": "Urban traffic, honking, city hum"
	},
	"construction_site": {
		"path": "res://assets/audio/sfx/ambient/construction_loop.ogg",
		"volume_db": -12.0,
		"context": "Jackhammers, heavy machinery, warning beeps"
	},
	"police_dispatch": {
		"path": "res://assets/audio/sfx/ambient/police_dispatch_loop.ogg",
		"volume_db": -18.0,
		"context": "Radio chatter, dispatcher calls, sirens in distance"
	},
	"residential_quiet": {
		"path": "res://assets/audio/sfx/ambient/residential_quiet_loop.ogg",
		"volume_db": -25.0,
		"context": "Peaceful neighborhood, light traffic, birds"
	},
	"turkey_flock": {
		"path": "res://assets/audio/sfx/ambient/turkey_cackling_loop.ogg",
		"volume_db": -12.0,
		"context": "Menacing turkey cackling, gobbles, wing flaps"
	},
	"park_ambience": {
		"path": "res://assets/audio/sfx/ambient/park_ambience_loop.ogg",
		"volume_db": -20.0,
		"context": "Birds chirping, leaves rustling, distant traffic"
	},
	"river_ambience": {
		"path": "res://assets/audio/sfx/ambient/river_ambience_loop.ogg",
		"volume_db": -22.0,
		"context": "Water flowing, birds, peaceful natural sounds"
	},
}

var current_ambient: String = ""
var current_player: AudioStreamPlayer
var is_playing: bool = false
var fade_speed: float = 2.0

func _ready() -> void:
	_setup_ambient_player()


func _setup_ambient_player() -> void:
	"""Initialize the ambient audio stream player"""
	current_player = AudioStreamPlayer.new()
	current_player.name = "AmbientPlayer"
	current_player.bus = AudioManager.BUS_AMBIENT
	current_player.volume_db = -80.0
	add_child(current_player)


func play_ambient(ambient_key: String, fade_in_time: float = 2.0) -> void:
	"""Play a specific ambient soundscape with fade-in"""
	if not ambient_loops.has(ambient_key):
		push_warning("[AmbientSFXManager] Unknown ambient: %s" % ambient_key)
		return
	
	if current_ambient == ambient_key and is_playing:
		return
	
	current_ambient = ambient_key
	var ambient_data = ambient_loops[ambient_key]
	
	# Fade out previous ambient if playing
	if is_playing:
		var fade_tween = create_tween()
		fade_tween.tween_property(current_player, "volume_db", -80.0, fade_speed * 0.5)
	
	# Load new ambient
	var stream = load(ambient_data.path)
	if stream:
		current_player.stream = stream
		current_player.bus = AudioManager.BUS_AMBIENT
		current_player.play()
		is_playing = true
		
		# Fade in
		var fade_tween = create_tween()
		fade_tween.tween_property(
			current_player,
			"volume_db",
			ambient_data.volume_db,
			fade_in_time
		)
		
		print("[AmbientSFXManager] Playing: %s - %s" % [ambient_key, ambient_data.context])
	else:
		push_warning("[AmbientSFXManager] Could not load: %s" % ambient_data.path)


func stop_ambient(fade_out_time: float = 2.0) -> void:
	"""Stop ambient soundscape with fade-out"""
	if not is_playing:
		return
	
	var tween = create_tween()
	tween.tween_property(current_player, "volume_db", -80.0, fade_out_time)
	tween.tween_callback(func(): current_player.stop(); is_playing = false)
	
	print("[AmbientSFXManager] Ambient stopped: %s" % current_ambient)


func get_ambient_by_district(district: String) -> String:
	"""Return appropriate ambient for a game district"""
	var ambient_map: Dictionary = {
		"trenches": "busy_street",
		"snob_40s": "residential_quiet",
		"downtown": "construction_site",
		"park": "park_ambience",
		"river": "river_ambience",
	}
	
	return ambient_map.get(district, "busy_street")


func cross_fade_ambient(from_ambient: String, to_ambient: String, duration: float = 3.0) -> void:
	"""Smoothly transition between two ambient sounds"""
	play_ambient(to_ambient, duration)
