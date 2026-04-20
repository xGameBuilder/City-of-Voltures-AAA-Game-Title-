extends Node
## RadioManager - Manages satirical Sacramento radio stations with commentary and ads
## Supports: News, Talk, Pop, Alt-Rock stations with fake DJs and parody content

class_name RadioManager

# Radio station definitions
var stations: Dictionary = {
	"nexus_news": {
		"name": "Nexus News Radio",
		"dj": "Chad Weatherby",
		"format": "News & Politics Parody",
		"stream_path": "res://assets/audio/radio/nexus_news_loop.ogg",
		"description": "Sacramento government puffery meets conspiracy theories"
	},
	"talk_107": {
		"name": "Talk 107 FM",
		"dj": "Karen's World",
		"format": "Outrage Talk",
		"stream_path": "res://assets/audio/radio/talk_107_loop.ogg",
		"description": "Local complaints about everything from bike lanes to development"
	},
	"pop_gold": {
		"name": "Pop Gold 99",
		"dj": "DJ Blade",
		"format": "Top 40 Parody",
		"stream_path": "res://assets/audio/radio/pop_gold_loop.ogg",
		"description": "Sacto pop hits mixed with questionable local ads"
	},
	"alternative_edge": {
		"name": "Alternative Edge",
		"dj": "Zeke Underground",
		"format": "Alt-Rock & Indie",
		"stream_path": "res://assets/audio/radio/alt_edge_loop.ogg",
		"description": "Quirky underground Sacramento music scene coverage"
	}
}

var current_station: String = ""
var current_player: AudioStreamPlayer
var ad_player: AudioStreamPlayer
var transition_speed: float = 1.0
var is_playing: bool = false

# Mock ad database (real ads would be generated)
var ads: Array[String] = [
	"res://assets/audio/radio/ads/real_estate_nightmare.ogg",
	"res://assets/audio/radio/ads/nimby_supplies.ogg",
	"res://assets/audio/radio/ads/corruption_law_firm.ogg",
	"res://assets/audio/radio/ads/homelessness_luxury_condos.ogg",
]

func _ready() -> void:
	_setup_players()


func _setup_players() -> void:
	"""Initialize radio audio stream players"""
	current_player = AudioStreamPlayer.new()
	current_player.name = "RadioStationPlayer"
	current_player.bus = AudioManager.BUS_RADIO
	add_child(current_player)
	
	ad_player = AudioStreamPlayer.new()
	ad_player.name = "RadioAdPlayer"
	ad_player.bus = AudioManager.BUS_RADIO
	ad_player.finished.connect(_on_ad_finished)
	add_child(ad_player)


func play_station(station_key: String) -> void:
	"""Switch to a specific radio station with smooth crossfade"""
	if not stations.has(station_key):
		push_error("[RadioManager] Unknown station: %s" % station_key)
		return
	
	if current_station == station_key and is_playing:
		return
	
	current_station = station_key
	var station_data = stations[station_key]
	
	# Crossfade effect
	var tween = create_tween()
	tween.tween_property(current_player, "volume_db", -80.0, transition_speed * 0.5)
	
	# Load and play new station
	var stream = load(station_data.stream_path)
	if stream:
		current_player.stream = stream
		current_player.play()
		is_playing = true
		
		tween.tween_property(current_player, "volume_db", 0.0, transition_speed * 0.5)
		print("[RadioManager] Now playing: %s - %s" % [station_data.name, station_data.dj])
	else:
		push_warning("[RadioManager] Could not load stream: %s" % station_data.stream_path)


func stop_station() -> void:
	"""Fade out current radio station"""
	if not is_playing:
		return
	
	var tween = create_tween()
	tween.tween_property(current_player, "volume_db", -80.0, transition_speed)
	tween.tween_callback(func(): current_player.stop(); is_playing = false)


func play_ad() -> void:
	"""Play random satirical ad"""
	if ads.is_empty():
		return
	
	var ad_path = ads[randi() % ads.size()]
	var stream = load(ad_path)
	
	if stream:
		ad_player.stream = stream
		ad_player.play()


func _on_ad_finished() -> void:
	"""Resume station after ad finishes"""
	pass  # Station loop continues automatically


func get_station_info(station_key: String) -> Dictionary:
	"""Get metadata about a station"""
	if stations.has(station_key):
		return stations[station_key]
	return {}


func get_all_stations() -> Array[String]:
	"""Return list of all station keys"""
	return stations.keys()
