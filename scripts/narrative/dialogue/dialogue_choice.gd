# dialogue_choice.gd
extends Resource
class_name DialogueChoice

## Player dialogue choice option with branching logic and conditions.

@export var choice_text: String = ""
@export var next_node_id: String = ""  # ID of next dialogue node to load
@export var conditions: Array[String] = []  # Flags like "has_cash", "knows_gang_name"
@export var effects: Array[String] = []  # Actions triggered: "give_item:cash", "set_flag:gang_aware"

## Validate that the choice is available given current game state.
func is_available(state_flags: Dictionary) -> bool:
	for condition in conditions:
		if not state_flags.get(condition, false):
			return false
	return true

## Apply effects when this choice is selected.
func apply_effects(state_flags: Dictionary) -> void:
	for effect in effects:
		var parts = effect.split(":", false)
		if parts.is_empty():
			continue
		
		var action = parts[0]
		var value = parts[1] if parts.size() > 1 else ""
		
		match action:
			"set_flag":
				state_flags[value] = true
			"quest_progress":
				# Quest system will handle this via signals
				pass
			"give_item":
				# Inventory system will handle this
				pass
