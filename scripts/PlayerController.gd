extends CharacterBody3D
class_name PlayerController

# Player movement and control script for Chet Miller
# Handles third-person movement, jumping, and input processing

# Movement constants
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SPRINT_MULTIPLIER = 2.0

# Camera settings
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

# Game systems
@onready var nimby_meter = $NimbyMeter
@onready var river_tokens = $RiverTokens
@onready var karen_rage = $KarenRage

# Input variables
var input_direction: Vector2 = Vector2.ZERO
var is_sprinting: bool = false
var is_jumping: bool = false

# Physics variables
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
    # Initialize camera position
    if camera_pivot:
        camera_pivot.rotation_degrees.y = 0  # Start facing forward

    # Connect system signals
    if nimby_meter:
        nimby_meter.heat_level_changed.connect(_on_heat_level_changed)
        nimby_meter.tank_summoned.connect(_on_tank_summoned)

    if river_tokens:
        river_tokens.tokens_changed.connect(_on_tokens_changed)

    if karen_rage:
        karen_rage.rage_activated.connect(_on_rage_activated)
        karen_rage.rage_deactivated.connect(_on_rage_deactivated)

func _physics_process(delta: float) -> void:
    # Handle gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump
    if is_jumping and is_on_floor():
        velocity.y = JUMP_VELOCITY
        is_jumping = false

    # Get input direction
    if InputMap.has_action("move_left") and InputMap.has_action("move_right") and InputMap.has_action("move_forward") and InputMap.has_action("move_backward"):
        input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    else:
        input_direction = Vector2.ZERO

    # Handle sprinting
    is_sprinting = Input.is_action_pressed("sprint") if InputMap.has_action("sprint") else false

    # Calculate movement direction relative to camera
    var direction = Vector3(input_direction.x, 0, input_direction.y).normalized()
    if direction.length() > 0:
        # Rotate direction based on camera orientation
        direction = direction.rotated(Vector3.UP, camera_pivot.rotation.y)

    # Apply movement
    var current_speed = SPEED
    if is_sprinting:
        current_speed *= SPRINT_MULTIPLIER

    if direction.length() > 0:
        velocity.x = direction.x * current_speed
        velocity.z = direction.z * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)
        velocity.z = move_toward(velocity.z, 0, current_speed)

    move_and_slide()

func _input(event: InputEvent) -> void:
    # Handle jump input
    if event.is_action_pressed("jump") and is_on_floor():
        is_jumping = true

    # Handle Karen Rage activation
    if InputMap.has_action("karen_rage") and event.is_action_pressed("karen_rage") and not karen_rage.is_active():
        karen_rage.activate_rage()

    # Handle camera rotation with mouse
    if event is InputEventMouseMotion and Input.is_action_pressed("camera_rotate"):
        camera_pivot.rotation_degrees.y -= event.relative.x * 0.1
        camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * 0.1, -90, 90)

# System signal handlers
func _on_heat_level_changed(new_level: int) -> void:
    print("NIMBY Heat Level: ", new_level)
    # TODO: Update UI, spawn enemies, etc.

func _on_tank_summoned() -> void:
    print("SacPD Tank summoned!")
    # TODO: Spawn tank, increase difficulty

func _on_tokens_changed(new_amount: int) -> void:
    print("River Tokens: ", new_amount)
    # TODO: Update UI

func _on_rage_activated(duration: float) -> void:
    print("Karen Rage activated for ", duration, " seconds!")
    # TODO: Visual effects, dialogue options

func _on_rage_deactivated() -> void:
    print("Karen Rage deactivated")
    # TODO: End effects

# Public methods for external systems
func get_movement_velocity() -> Vector3:
    return velocity

func is_player_sprinting() -> bool:
    return is_sprinting

func get_input_direction() -> Vector2:
    return input_direction

# System access methods
func get_nimby_meter():
    return nimby_meter

func get_river_tokens():
    return river_tokens

func get_karen_rage():
    return karen_rage