extends Resource
class_name GameBalance

## City of Vultures - Milestone 4 Balance Configuration
## Master game balance resource centralizing all tuning parameters
## Satirical tuning for Sacramento open-world chaos

# ============================================================================
# GAME BALANCE CONSTANTS
# ============================================================================

## Game version for tracking balance changes
const BALANCE_VERSION = "1.0.0"
const LAST_UPDATED = "2026-04-20"

# ============================================================================
# DIFFICULTY SCALING
# ============================================================================

## Player starter district difficulty multiplier
var starter_difficulty_multiplier: float = 0.8

## Mid-game district difficulty multiplier
var midgame_difficulty_multiplier: float = 1.0

## Endgame district difficulty multiplier
var endgame_difficulty_multiplier: float = 1.5

## Heat decay rate (units/second) - affects NIMBY Meter cooldown
var base_heat_decay_rate: float = 0.15

# ============================================================================
# KAREN RAGE TUNING
# ============================================================================

## Time scale during rage (0.3 = 30% speed)
var karen_rage_time_scale: float = 0.3

## Duration of Karen Rage effect (seconds)
var karen_rage_duration: float = 10.0

## Cooldown between Karen Rage activations (seconds)
var karen_rage_cooldown: float = 60.0

## NIMBY Meter stars required to activate Karen Rage
var karen_rage_activation_threshold: int = 3

## Heat reduction per successful Karen Rage usage
var karen_rage_heat_reduction: float = 1.5

# ============================================================================
# NIMBY METER CONFIGURATION
# ============================================================================

## Maximum heat level (stars)
var max_heat_level: int = 5

## Heat per small crime (vandalism, minor theft)
var heat_per_small_crime: float = 0.25

## Heat per medium crime (assault, car theft)
var heat_per_medium_crime: float = 0.75

## Heat per major crime (robbery, manslaughter)
var heat_per_major_crime: float = 1.5

## Heat per NPC calling police (Nextdoor post equivalent)
var heat_per_npc_report: float = 0.5

## Heat from getting spotted by gang
var heat_per_gang_spot: float = 1.0

## ===== HEAT ESCALATION RESPONSES =====

## Heat Level 1-2: Social media posts (no immediate threat)
## Heat Level 3: Gang kids patrol increases; turkeys become aggressive
## Heat Level 4: SacPD arrives; diplomatic options available
## Heat Level 5: Military police tank arrives; Karen Rage becomes critical

var heat_level_escalations: Array = [
	{
		"level": 0,
		"threshold": 0.0,
		"name": "Harmless",
		"npc_response": "ignore",
		"threat_level": 0
	},
	{
		"level": 1,
		"threshold": 1.0,
		"name": "Social Media Buzz",
		"npc_response": "few_stares",
		"threat_level": 0
	},
	{
		"level": 2,
		"threshold": 2.0,
		"name": "Nextdoor Alert",
		"npc_response": "increased_reporting",
		"threat_level": 1
	},
	{
		"level": 3,
		"threshold": 3.0,
		"name": "Gang Alert (Karen Rage Available)",
		"npc_response": "gang_patrol_increase",
		"threat_level": 2
	},
	{
		"level": 4,
		"threshold": 4.0,
		"name": "Police Response",
		"npc_response": "police_chase",
		"threat_level": 3
	},
	{
		"level": 5,
		"threshold": 5.0,
		"name": "Tank Summoned",
		"npc_response": "military_response",
		"threat_level": 4
	}
]

# ============================================================================
# RIVER TOKENS ECONOMY
# ============================================================================

## Starting tokens
var starting_tokens: int = 200

## ===== EARNING RATES =====

## Tokens per can recycled (hourly rate simulation: 5 cans/hour)
var tokens_per_can: int = 1

## Tokens per hour of recycling activity
var tokens_per_recycling_hour: int = 5

## Tokens per vending sale
var tokens_per_vending_sale: int = 10

## Tokens per influencing NPC (variable: 5-15 based on NPC tier)
var tokens_per_influence_npc_min: int = 5
var tokens_per_influence_npc_max: int = 15

## Bonus tokens for completing missions
var tokens_per_mission_completion: int = 50

## Bonus tokens for "clean" completion (no heat above Level 2)
var tokens_bonus_clean_completion: int = 25

## Hourly passive income from street vending (passive revenue)
var tokens_per_passive_hour: int = 3

## ===== SPENDING COSTS =====

## Cost to fill vehicle gas tank
var cost_gasoline: int = 2

## Cost to buy food (health recovery)
var cost_food: int = 3

## Cost to bribe a single NPC
var cost_npc_bribe: int = 15

## Cost to bribe police (reduce heat by 1 level)
var cost_police_bribe: int = 50

## Cost for vehicle repair
var cost_vehicle_repair: int = 25

## Cost for health upgrade (permanent +10 HP)
var cost_health_upgrade: int = 40

## Cost for speed upgrade
var cost_speed_upgrade: int = 35

## Cost for persuasion upgrade (cheaper bribes)
var cost_persuasion_upgrade: int = 60

# ============================================================================
# VEHICLE PHYSICS
# ============================================================================

## Random "Check Engine" failure chance (%)
var vehicle_failure_chance: float = 0.20

## Speed reduction when engine fails (%)
var engine_failure_speed_reduction: float = 0.40

## Recovery time for dashboard "fix" (seconds)
var engine_fix_time: float = 3.0

## ===== VEHICLE HANDLING RATINGS =====

var vehicle_types: Array = [
	{
		"name": "2004 Nissan Altima (Base)",
		"handling": 0.6,
		"acceleration": 0.7,
		"max_speed": 95.0,
		"description": "Missing bumper, smells like old pizza"
	},
	{
		"name": "Prius (Eco-Friendly)",
		"handling": 0.75,
		"acceleration": 0.4,
		"max_speed": 85.0,
		"description": "Respectable gas mileage, terrible in chases"
	},
	{
		"name": "Lifted Truck (Overcompensation)",
		"handling": 0.4,
		"acceleration": 0.8,
		"max_speed": 110.0,
		"description": "Fast but terrible cornering; compensates for something"
	},
	{
		"name": "City Truck (Leaf Pickup)",
		"handling": 0.5,
		"acceleration": 0.5,
		"max_speed": 75.0,
		"description": "Official city vehicle; great for disguises"
	},
	{
		"name": "Tesla Model 3 (Tech Bro)",
		"handling": 0.85,
		"acceleration": 0.9,
		"max_speed": 130.0,
		"description": "Stolen from mansion; autopilot unreliable on pothole roads"
	},
	{
		"name": "Vespa (Scooter Gang)",
		"handling": 0.95,
		"acceleration": 0.3,
		"max_speed": 45.0,
		"description": "Hilariously slow; great for mall escapes"
	}
]

# ============================================================================
# NPC BEHAVIOR
# ============================================================================

## ===== FERAL TURKEY AGGRESSION =====

## Turkeys become aggressive when player is within this distance (units)
var turkey_aggression_distance: float = 20.0

## Turkeys flock when within this distance of each other
var turkey_flock_distance: float = 15.0

## Maximum turkeys in a flock
var max_turkey_flock_size: int = 8

## Damage per turkey peck
var turkey_peck_damage: float = 5.0

## Heat added when turkey attacks player
var heat_from_turkey_attack: float = 0.25

## ===== GANG KID PATROL ROUTES =====

## Patrol route density (kids per district)
var gang_kids_per_district: int = 3

## Patrol speed for gang kids
var gang_kid_patrol_speed: float = 4.5

## Patrol route cycle time (seconds before repeating)
var gang_kid_patrol_cycle: float = 120.0

## Vision range for gang kids (detection distance)
var gang_kid_vision_range: float = 30.0

## Aggressiveness multiplier at different heat levels
var gang_kid_aggression_curve: Array = [
	{ "heat_level": 0, "aggression": 0.0 },
	{ "heat_level": 1, "aggression": 0.3 },
	{ "heat_level": 2, "aggression": 0.6 },
	{ "heat_level": 3, "aggression": 1.0 },
	{ "heat_level": 4, "aggression": 1.3 },
	{ "heat_level": 5, "aggression": 1.5 }
]

## ===== CIVILIAN REACTIONS TO KAREN RAGE =====

## Fear radius of Karen Rage effect
var karen_rage_fear_radius: float = 50.0

## Civilians flee if within fear radius during Karen Rage
var civilian_flee_chance_during_rage: float = 0.85

## Duration of civilian fear state after rage ends (seconds)
var civilian_fear_duration: float = 15.0

## Diplomatic conversation bonus during Karen Rage
var karen_rage_conversation_bonus: float = 1.5

## Chance to "demand supervisor" and reduce heat during rage
var karen_rage_heat_reduction_chance: float = 0.75

# ============================================================================
# NPC TIERS & BRIBING
# ============================================================================

var npc_bribe_tiers: Array = [
	{
		"tier": "Homeless Encampment Dweller",
		"bribe_cost": 5,
		"influence_tokens": 5,
		"dialogue_options": 2,
		"description": "Easily influenced; low expectations"
	},
	{
		"tier": "Gang Kid",
		"bribe_cost": 15,
		"influence_tokens": 8,
		"dialogue_options": 1,
		"description": "Willing to negotiate; respects authority of Karen Rage"
	},
	{
		"tier": "Middle-Class Karen",
		"bribe_cost": 25,
		"influence_tokens": 12,
		"dialogue_options": 3,
		"description": "Easily intimidated by supervisor-demanding tactics"
	},
	{
		"tier": "Police Officer",
		"bribe_cost": 50,
		"influence_tokens": 20,
		"dialogue_options": 2,
		"description": "Jaded; prefers direct financial negotiation"
	},
	{
		"tier": "Bureaucrat (City Council)",
		"bribe_cost": 100,
		"influence_tokens": 30,
		"dialogue_options": 4,
		"description": "Complex negotiation; responds to red tape counterarguments"
	}
]

# ============================================================================
# DIFFICULTY SCALING PROGRESSION
# ============================================================================

var difficulty_tiers: Array = [
	{
		"tier": "Starter District (Del Paso Heights)",
		"heat_decay_multiplier": 1.5,
		"npc_aggression_multiplier": 0.7,
		"vehicle_failure_chance_modifier": -0.05,
		"tokens_earning_multiplier": 1.0,
		"description": "Forgiving introduction to chaos"
	},
	{
		"tier": "Mid-Game District (Snob 40s)",
		"heat_decay_multiplier": 1.0,
		"npc_aggression_multiplier": 1.0,
		"vehicle_failure_chance_modifier": 0.0,
		"tokens_earning_multiplier": 1.2,
		"description": "Balanced chaos; Karens are sophisticated"
	},
	{
		"tier": "Endgame District (Hoe Strip / Downtown)",
		"heat_decay_multiplier": 0.6,
		"npc_aggression_multiplier": 1.4,
		"vehicle_failure_chance_modifier": 0.1,
		"tokens_earning_multiplier": 1.5,
		"description": "Ruthless; every decision matters"
	},
	{
		"tier": "Chaos Zone (The Wilds)",
		"heat_decay_multiplier": 0.3,
		"npc_aggression_multiplier": 2.0,
		"vehicle_failure_chance_modifier": 0.2,
		"tokens_earning_multiplier": 2.0,
		"description": "Turkey kingdom; no rules apply"
	}
]

# ============================================================================
# SATIRICAL TUNING NOTES
# ============================================================================

## Game feel tuning notes (for design reference)
var design_notes: String = """
SATIRICAL BALANCE PHILOSOPHY:
================================

1. KAREN RAGE ABSURDITY:
   - 60-second cooldown ensures it's not overpowered
   - Activation at 3+ stars rewards strategic planning
   - "Demanding a supervisor" should feel ridiculous but overpowered
   - Civilians fleeing in fear parodies suburban entitlement

2. NIMBY METER ESCALATION:
   - Nextdoor posts (Level 1-2) poke fun at social media culture
   - Gang patrol increase (Level 3) shows escalating street life
   - Police response (Level 4) is inevitable but avoidable
   - Tank appearance (Level 5) is peak Sacramento absurdity
   - Heat decay allows skilled players to manage consequences

3. RIVER TOKENS ECONOMY:
   - Recycling (5/hour) is slow, satirizing environmental performatism
   - Vending (10/sale) rewards hustling
   - Influencing (5-15) depends on NPC sophistication
   - Police bribes (50 tokens) are expensive, reflecting systemic corruption
   - Food (3 tokens) is cheap; gas (2) reflects broke lifestyle

4. VEHICLE FAILURES:
   - 20% Check Engine failure parodies old Sacramento cars
   - Tesla autopilot unreliability on pothole roads = peak satire
   - Vespa speed (45 mph) makes scooter gang chases absurd

5. NPC DIVERSITY:
   - Homeless dwellers are negotiable (realism/respect)
   - Gang kids respect authority figures (Karen Rage meta)
   - Karens vulnerable to supervisor-demanding (satirical power fantasy)
   - Police need money (systemic cynicism)

6. DIFFICULTY SCALING:
   - Starter district forgives heat (tutorials feel safe)
   - Mid-game raises stakes with better token earn rates
   - Endgame heat decay slows (consequences last longer)
   - Chaos Zone is unforgiving (for hardcore players seeking challenge)
"""

# ============================================================================
# HELPER METHODS
# ============================================================================

func get_heat_level_description(level: int) -> String:
	"""Returns the name/description of a heat level."""
	for escalation in heat_level_escalations:
		if escalation["level"] == level:
			return escalation["name"]
	return "Unknown"

func get_vehicle_by_name(vehicle_name: String) -> Dictionary:
	"""Returns vehicle stats by name."""
	for vehicle in vehicle_types:
		if vehicle["name"] == vehicle_name:
			return vehicle
	return {}

func get_npc_bribe_tier(tier_name: String) -> Dictionary:
	"""Returns NPC bribe tier info."""
	for tier in npc_bribe_tiers:
		if tier["tier"] == tier_name:
			return tier
	return {}

func get_difficulty_tier(tier_name: String) -> Dictionary:
	"""Returns difficulty tier scaling."""
	for tier in difficulty_tiers:
		if tier["tier"] == tier_name:
			return tier
	return {}
