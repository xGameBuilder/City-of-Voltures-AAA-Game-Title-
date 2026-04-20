extends Node
class_name NimbyMeter

# NIMBY Meter heat system
# Tracks player heat level from social media posts to SacPD Tank

signal heat_level_changed(new_level: int)
signal tank_summoned

const MAX_HEAT_LEVEL = 5
const HEAT_DECAY_RATE = 0.1  # Heat decreases over time

var current_heat: float = 0.0
var heat_level: int = 0

func _process(delta: float) -> void:
    # Decay heat over time
    if current_heat > 0:
        current_heat -= HEAT_DECAY_RATE * delta
        update_heat_level()

func add_heat(amount: float) -> void:
    current_heat += amount
    update_heat_level()

func remove_heat(amount: float) -> void:
    current_heat = max(0, current_heat - amount)
    update_heat_level()

func update_heat_level() -> void:
    var new_level = int(current_heat)
    new_level = clamp(new_level, 0, MAX_HEAT_LEVEL)

    if new_level != heat_level:
        heat_level = new_level
        heat_level_changed.emit(heat_level)

        if heat_level >= MAX_HEAT_LEVEL:
            tank_summoned.emit()

func get_heat_level() -> int:
    return heat_level

func get_heat_percentage() -> float:
    return current_heat / MAX_HEAT_LEVEL