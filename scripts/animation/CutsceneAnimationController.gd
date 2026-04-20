# Animation controller for cutscene animations
# Mission briefings, dialogue reactions, radio host gestures, cinematics
extends BaseAnimationController
class_name CutsceneAnimationController

# Cutscene animation states
const STATE_IDLE = "Idle"
const STATE_BRIEFING_LISTEN = "BriefingListen"  # Chet reacting during briefing
const STATE_BRIEFING_REACT = "BriefingReact"
const STATE_GESTURE_POINTING = "GesturePointing"
const STATE_GESTURE_SHRUG = "GestureShrug"
const STATE_GESTURE_CELEBRATION = "GestureCelebration"
const STATE_GESTURE_CONFUSED = "GestureConfused"
const STATE_SITTING = "Sitting"
const STATE_STANDING = "Standing"
const STATE_TALKING = "Talking"
const STATE_LISTENING = "Listening"

# Camera control for cutscenes
@export var camera: Camera3D
@export var camera_smooth_time: float = 0.5

# Animation targets
@export var animation_player: AnimationPlayer
@export var skeletal_mesh: MeshInstance3D

# Cutscene state
var current_cutscene: String = ""
var is_playing_cutscene: bool = false
var camera_initial_transform: Transform3D

# Signals
signal cutscene_started(cutscene_name: String)
signal cutscene_finished
signal dialogue_line_started(line: String)
signal gesture_completed(gesture: String)

func _ready() -> void:
	super._ready()
	
	if camera:
		camera_initial_transform = camera.global_transform
	
	transition_to(STATE_IDLE)

# Play mission briefing cutscene with Chet reactions
func play_mission_briefing(briefing_dialogue: Array[String]) -> void:
	is_playing_cutscene = true
	current_cutscene = "mission_briefing"
	cutscene_started.emit(current_cutscene)
	
	transition_to(STATE_BRIEFING_LISTEN)
	
	# Play each dialogue line with character animations
	for i in range(briefing_dialogue.size()):
		var line = briefing_dialogue[i]
		dialogue_line_started.emit(line)
		
		# Vary reactions based on dialogue
		if i % 3 == 0:
			play_gesture("shrug")
		elif i % 3 == 1:
			play_gesture("nod")
		else:
			play_gesture("confused")
		
		# Wait for reaction animation to complete
		await animation_player.animation_finished
	
	finish_cutscene()

# Play gesture animation (shrug, point, celebrate, confused, nod)
func play_gesture(gesture_type: String) -> void:
	var gesture_state = STATE_IDLE
	
	match gesture_type.to_lower():
		"pointing":
			gesture_state = STATE_GESTURE_POINTING
		"shrug":
			gesture_state = STATE_GESTURE_SHRUG
		"celebration":
			gesture_state = STATE_GESTURE_CELEBRATION
		"confused":
			gesture_state = STATE_GESTURE_CONFUSED
		"nod":
			gesture_state = STATE_GESTURE_POINTING  # Reuse for nod animation
		"talking":
			gesture_state = STATE_TALKING
	
	transition_to(gesture_state)
	gesture_completed.emit(gesture_type)

# Change animation to sitting pose (for briefing scenes)
func sit_down() -> void:
	transition_to(STATE_SITTING)

# Return to standing
func stand_up() -> void:
	transition_to(STATE_STANDING)

# Generic cutscene player - handles by animation name
func play_cutscene_animation(animation_name: String, duration: float = 0.0) -> void:
	if animation_player and animation_player.has_animation(animation_name):
		is_playing_cutscene = true
		animation_player.play(animation_name)
		
		if duration > 0:
			await get_tree().create_timer(duration).timeout
		else:
			await animation_player.animation_finished
		
		is_playing_cutscene = false

# Control camera for cutscenes (smooth transition to target)
func set_camera_focus(target_position: Vector3, target_rotation: Vector3) -> void:
	if not camera:
		return
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(camera, "global_position", target_position, camera_smooth_time)
	tween.parallel().tween_property(camera, "rotation", target_rotation, camera_smooth_time)

# Reset camera to initial position
func reset_camera() -> void:
	if camera:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(true)
		
		tween.tween_property(camera, "global_position", camera_initial_transform.origin, camera_smooth_time)
		tween.tween_property(camera, "rotation", camera_initial_transform.basis.get_euler(), camera_smooth_time)

# Radio host gesture sequence (for radio station broadcasts)
func play_radio_host_gesture(gesture: String, speech_duration: float) -> void:
	play_gesture(gesture)
	
	# Radio host speaks while gesturing
	transition_to(STATE_TALKING)
	
	await get_tree().create_timer(speech_duration).timeout
	
	transition_to(STATE_LISTENING)

# End cutscene and return to normal
func finish_cutscene() -> void:
	is_playing_cutscene = false
	current_cutscene = ""
	
	transition_to(STATE_IDLE)
	reset_camera()
	
	cutscene_finished.emit()

# Check if currently playing a cutscene
func is_in_cutscene() -> bool:
	return is_playing_cutscene

# Get current cutscene name
func get_current_cutscene() -> String:
	return current_cutscene
