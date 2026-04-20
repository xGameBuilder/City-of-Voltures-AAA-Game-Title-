extends Node
class_name RiverTokens

# River Tokens economy system
# Manages currency earned through various activities

signal tokens_changed(new_amount: int)

var current_tokens: int = 0

func _ready():
    # Initialize with starting tokens
    current_tokens = 100  # Starting amount

func add_tokens(amount: int) -> void:
    current_tokens += amount
    tokens_changed.emit(current_tokens)

func spend_tokens(amount: int) -> bool:
    if current_tokens >= amount:
        current_tokens -= amount
        tokens_changed.emit(current_tokens)
        return true
    return false

func get_tokens() -> int:
    return current_tokens

# Specific earning methods
func earn_from_recycling(cans: int) -> void:
    var tokens_earned = cans * 2  # 2 tokens per can
    add_tokens(tokens_earned)

func earn_from_vending(sales: int) -> void:
    var tokens_earned = sales * 5  # 5 tokens per sale
    add_tokens(tokens_earned)

func earn_from_influencing(influence: int) -> void:
    var tokens_earned = influence * 10  # 10 tokens per influence point
    add_tokens(tokens_earned)