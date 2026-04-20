## Idle state - NPC rests or waits.
class_name AIIdleState extends AIState

@export var idle_duration: float = 3.0  # How long to idle before transitioning
@export var idle_animation: String = "idle"

var idle_timer: float = 0.0


func enter(_context: Dictionary = {}) -> void:
	idle_timer = 0.0
	state_machine.desired_velocity = Vector3.ZERO


func physics_update(delta: float) -> void:
	idle_timer += delta


func process(delta: float) -> void:
	# Check if we should patrol or detect threats
	if idle_timer >= idle_duration:
		if state_machine.current_target:
			transition_to("Alert")
		else:
			# Default to patrol if available
			if "Patrol" in state_machine.states:
				transition_to("Patrol")


func exit() -> void:
	pass
