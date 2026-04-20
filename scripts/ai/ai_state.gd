## Base class for all NPC states.
## Implements enter/exit lifecycle, physics updates, and state-to-state transitions.
class_name AIState extends Node

signal transitioned(target_state: String)

@export var state_name: String = ""
var state_machine: AIBaseNPC  # Reference to the owning NPC controller

func _ready() -> void:
	if state_name == "":
		state_name = name


## Called when entering this state
func enter(_context: Dictionary = {}) -> void:
	pass


## Called every physics frame while in this state
func physics_update(delta: float) -> void:
	pass


## Called every frame while in this state
func process(delta: float) -> void:
	pass


## Called when exiting this state
func exit() -> void:
	pass


## Request a transition to another state
func transition_to(target_state: String, context: Dictionary = {}) -> void:
	transitioned.emit(target_state)
	if state_machine:
		state_machine.transition_to(target_state, context)
