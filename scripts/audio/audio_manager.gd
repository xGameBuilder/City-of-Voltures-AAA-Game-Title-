extends Node
## Global AudioManager - Controls master audio systems, bus routing, and mixing
## Initialize as an AutoLoad in project settings

class_name AudioManager

# Bus names for organization
const BUS_MASTER = "Master"
const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"
const BUS_VOICE = "Voice"
const BUS_RADIO = "Radio"
const BUS_UI = "UI"

# Sub-buses for granular control
const BUS_AMBIENT = "Ambient"
const BUS_CHARACTER = "Character"
const BUS_VEHICLE = "Vehicle"

# Volume state (dB)
var master_volume_db: float = -5.0
var music_volume_db: float = 0.0
var sfx_volume_db: float = 0.0
var voice_volume_db: float = 0.0
var radio_volume_db: float = -3.0
var ui_volume_db: float = -10.0

# Manager instances
var radio_manager: RadioManager
var ambient_manager: AmbientSFXManager
var character_manager: CharacterSFXManager
var vehicle_manager: VehicleSFXManager
var ui_sfx_manager: UISFXManager
var music_manager: MusicManager

# Voice pool for performance
var voice_pool: AudioVoicePool

var is_initialized: bool = false

func _ready() -> void:
	if is_initialized:
		return
	
	_setup_audio_buses()
	_initialize_managers()
	is_initialized = true
	print("[AudioManager] Initialized - Audio system ready")


func _setup_audio_buses() -> void:
	"""Creates bus hierarchy: Master > [Music, SFX (Ambient/Character/Vehicle), Voice, UI, Radio]"""
	var audio_server = AudioServer
	
	# Create main buses (skip Master, it exists by default)
	_create_bus_if_missing(BUS_MUSIC, BUS_MASTER)
	_create_bus_if_missing(BUS_SFX, BUS_MASTER)
	_create_bus_if_missing(BUS_VOICE, BUS_MASTER)
	_create_bus_if_missing(BUS_RADIO, BUS_MASTER)
	_create_bus_if_missing(BUS_UI, BUS_MASTER)
	
	# Create SFX sub-buses
	_create_bus_if_missing(BUS_AMBIENT, BUS_SFX)
	_create_bus_if_missing(BUS_CHARACTER, BUS_SFX)
	_create_bus_if_missing(BUS_VEHICLE, BUS_SFX)
	
	# Apply initial volumes
	set_master_volume(master_volume_db)
	set_music_volume(music_volume_db)
	set_sfx_volume(sfx_volume_db)
	set_voice_volume(voice_volume_db)
	set_radio_volume(radio_volume_db)
	set_ui_volume(ui_volume_db)


func _create_bus_if_missing(bus_name: String, parent_bus: String = BUS_MASTER) -> void:
	"""Safely creates a bus if it doesn't exist"""
	var audio_server = AudioServer
	var bus_idx = audio_server.get_bus_index(bus_name)
	
	if bus_idx == -1:  # Bus doesn't exist
		audio_server.add_bus()
		var new_idx = audio_server.bus_count - 1
		audio_server.set_bus_name(new_idx, bus_name)
		
		# Set parent bus
		var parent_idx = audio_server.get_bus_index(parent_bus)
		if parent_idx != -1:
			audio_server.set_bus_send(new_idx, parent_bus)


func _initialize_managers() -> void:
	"""Instantiate all audio subsystem managers"""
	# Initialize voice pool first
	voice_pool = AudioVoicePool.new()
	add_child(voice_pool)
	
	# Initialize managers
	radio_manager = RadioManager.new()
	add_child(radio_manager)
	
	ambient_manager = AmbientSFXManager.new()
	add_child(ambient_manager)
	
	character_manager = CharacterSFXManager.new()
	add_child(character_manager)
	
	vehicle_manager = VehicleSFXManager.new()
	add_child(vehicle_manager)
	
	ui_sfx_manager = UISFXManager.new()
	add_child(ui_sfx_manager)
	
	music_manager = MusicManager.new()
	add_child(music_manager)


# Volume control methods (use dB for logarithmic audio scaling)
func set_master_volume(db: float) -> void:
	master_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_MASTER), master_volume_db)


func set_music_volume(db: float) -> void:
	music_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_MUSIC), music_volume_db)


func set_sfx_volume(db: float) -> void:
	sfx_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_SFX), sfx_volume_db)


func set_voice_volume(db: float) -> void:
	voice_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_VOICE), voice_volume_db)


func set_radio_volume(db: float) -> void:
	radio_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_RADIO), radio_volume_db)


func set_ui_volume(db: float) -> void:
	ui_volume_db = clamp(db, -80.0, 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_UI), ui_volume_db)


# Convenience methods for common audio operations
func play_ui_sound(sound_path: String, volume_db: float = 0.0, loop: bool = false) -> void:
	if ui_sfx_manager:
		ui_sfx_manager.play_sound(sound_path, volume_db, loop)


func play_radio(station: String) -> void:
	if radio_manager:
		radio_manager.play_station(station)


func stop_radio() -> void:
	if radio_manager:
		radio_manager.stop_station()


func get_current_radio_station() -> String:
	if radio_manager:
		return radio_manager.current_station
	return ""


func play_character_sound(sound_path: String, position: Vector3 = Vector3.ZERO, volume_db: float = 0.0) -> void:
	if character_manager:
		character_manager.play_sound(sound_path, position, volume_db)


func play_karen_rage(intensity: float = 1.0) -> void:
	if character_manager:
		character_manager.play_karen_rage(intensity)


func play_footstep(surface: String, position: Vector3 = Vector3.ZERO) -> void:
	if character_manager:
		character_manager.play_footstep(surface, position)


func play_music(track: String, fade_in: float = 1.0) -> void:
	if music_manager:
		music_manager.play_track(track, fade_in)


func stop_music(fade_out: float = 1.0) -> void:
	if music_manager:
		music_manager.stop_track(fade_out)


func play_ambient(ambient_type: String) -> void:
	if ambient_manager:
		ambient_manager.play_ambient(ambient_type)


func stop_ambient() -> void:
	if ambient_manager:
		ambient_manager.stop_ambient()
