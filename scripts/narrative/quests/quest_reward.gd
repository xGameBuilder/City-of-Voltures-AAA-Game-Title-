# quest_reward.gd
extends Resource
class_name QuestReward

## Reward data for completing a quest.

enum RewardType { RIVER_TOKENS, ITEM, UNLOCK_LOCATION, UNLOCK_ABILITY, REPUTATION }

@export var reward_type: RewardType = RewardType.RIVER_TOKENS
@export var amount: int = 0
@export var item_id: String = ""  # For ITEM rewards
@export var location_id: String = ""  # For UNLOCK_LOCATION rewards
@export var ability_id: String = ""  # For UNLOCK_ABILITY rewards
@export var faction: String = ""  # For REPUTATION rewards (e.g., "gang_kids", "karens")

## Get a human-readable description of the reward.
func get_description() -> String:
	match reward_type:
		RewardType.RIVER_TOKENS:
			return "%d River Tokens" % amount
		RewardType.ITEM:
			return "Item: %s" % item_id
		RewardType.UNLOCK_LOCATION:
			return "Unlocked: %s" % location_id
		RewardType.UNLOCK_ABILITY:
			return "Unlocked: %s" % ability_id
		RewardType.REPUTATION:
			return "Reputation with %s" % faction
		_:
			return "Unknown reward"
