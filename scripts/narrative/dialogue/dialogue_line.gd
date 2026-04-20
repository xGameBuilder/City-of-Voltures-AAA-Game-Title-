# dialogue_line.gd
extends Resource
class_name DialogueLine

## A single line of dialogue spoken by a character.

@export var node_id: String = ""  # Unique identifier for this dialogue node
@export var speaker: String = ""  # Character name
@export var portrait: Texture2D  # Character portrait (optional)
@export_multiline var text: String = ""  # The actual dialogue text
@export var choices: Array[DialogueChoice] = []  # Player responses
@export var next_line_id: String = ""  # Auto-advance if no choices
@export var conditions: Array[String] = []  # Only show if these flags are true
@export var duration: float = 0.0  # How long to display (0 = manual advance)

## Check if this line should be visible given current state.
func is_available(state_flags: Dictionary) -> bool:
	for condition in conditions:
		if not state_flags.get(condition, false):
			return false
	return true

## Get filtered choices based on available conditions.
func get_available_choices(state_flags: Dictionary) -> Array[DialogueChoice]:
	var available: Array[DialogueChoice] = []
	for choice in choices:
		if choice.is_available(state_flags):
			available.append(choice)
	return available
