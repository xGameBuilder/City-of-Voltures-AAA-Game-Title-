extends Node
class_name KarenRage

# Post-Suburban Karen Rage ability
# Slows time and allows dialogue-based resolution of conflicts

signal rage_activated(duration: float)
signal rage_deactivated

const RAGE_DURATION = 10.0
const TIME_SCALE_DURING_RAGE = 0.3  # Slow motion

var is_rage_active: bool = false
var rage_timer: float = 0.0

func _process(delta: float) -> void:
    if is_rage_active:
        rage_timer -= delta
        if rage_timer <= 0:
            deactivate_rage()

func activate_rage() -> void:
    if not is_rage_active:
        is_rage_active = true
        rage_timer = RAGE_DURATION
        Engine.time_scale = TIME_SCALE_DURING_RAGE
        rage_activated.emit(RAGE_DURATION)

func deactivate_rage() -> void:
    if is_rage_active:
        is_rage_active = false
        Engine.time_scale = 1.0
        rage_deactivated.emit()

func is_active() -> bool:
    return is_rage_active

func get_remaining_time() -> float:
    return rage_timer