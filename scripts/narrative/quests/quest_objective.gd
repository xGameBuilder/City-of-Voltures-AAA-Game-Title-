# quest_objective.gd
extends Resource
class_name QuestObjective

## A single objective within a quest.

enum ObjectiveType { KILL, COLLECT, REACH_LOCATION, TALK_TO_NPC, STEAL_ITEM, AVOID_DETECTION }

@export var objective_id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
@export var objective_type: ObjectiveType = ObjectiveType.KILL
@export var target: String = ""  # Enemy name, item ID, NPC name, or location
@export var required_count: int = 1
@export var current_count: int = 0
@export var is_hidden: bool = false  # Hide from quest tracker until conditions met
@export var is_optional: bool = false  # Can complete quest without this

## Check if this objective is complete.
func is_complete() -> bool:
	return current_count >= required_count

## Progress this objective.
func progress(amount: int = 1) -> void:
	current_count = mini(current_count + amount, required_count)

## Reset progress (for quest restart/reload).
func reset() -> void:
	current_count = 0
