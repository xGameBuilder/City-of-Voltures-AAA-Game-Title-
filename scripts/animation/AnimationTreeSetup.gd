# Utility for setting up AnimationTree nodes and state machines
# Programmatically creates animation tree structures for characters
extends Node
class_name AnimationTreeSetup

# Create a standard locomotion animation tree with BlendSpace2D
# Used for characters with directional movement (Chet, NPCs, animals)
static func create_locomotion_tree(animation_player: AnimationPlayer) -> AnimationTree:
	var anim_tree = AnimationTree.new()
	anim_tree.name = "AnimationTree"
	anim_tree.anim_player = animation_player.get_path()
	
	# Create root AnimationNodeStateMachine
	var root = AnimationNodeStateMachine.new()
	
	# Create locomotion BlendSpace2D
	var locomotion = AnimationNodeBlendSpace2D.new()
	locomotion.min_space = Vector2(-1, -1)
	locomotion.max_space = Vector2(1, 1)
	
	# Add animation points to blend space
	# Layout: 4-directional with cardinal and diagonal positions
	if animation_player.has_animation("Idle"):
		locomotion.add_point(Vector2(0, 0), animation_player.get_animation("Idle"))
	if animation_player.has_animation("Walk"):
		locomotion.add_point(Vector2(0, 0.5), animation_player.get_animation("Walk"))
	if animation_player.has_animation("Run"):
		locomotion.add_point(Vector2(0, 1.0), animation_player.get_animation("Run"))
	
	# Create Jump state
	var jump_node = AnimationNodeAnimation.new()
	jump_node.animation = "Jump"
	
	# Create state machine transitions
	root.add_node("Movement", locomotion)
	root.add_node("Jump", jump_node)
	root.add_transition("Movement", "Jump", AnimationNodeStateMachineTransition.new())
	root.add_transition("Jump", "Movement", AnimationNodeStateMachineTransition.new())
	
	# Set initial state
	root.start_node = "Movement"
	
	# Assign root and return
	anim_tree.root_node = root
	return anim_tree

# Create a state machine-based animation tree for NPCs/complex characters
static func create_state_machine_tree(
	animation_player: AnimationPlayer,
	states: Array[String],
	transitions: Array[Dictionary] = []
) -> AnimationTree:
	var anim_tree = AnimationTree.new()
	anim_tree.name = "AnimationTree"
	anim_tree.anim_player = animation_player.get_path()
	
	var root = AnimationNodeStateMachine.new()
	
	# Create state nodes
	for state in states:
		if animation_player.has_animation(state):
			var node = AnimationNodeAnimation.new()
			node.animation = state
			root.add_node(state, node)
	
	# Add default transitions (from each state to all others)
	if transitions.is_empty():
		for i in range(states.size()):
			for j in range(states.size()):
				if i != j:
					var transition = AnimationNodeStateMachineTransition.new()
					transition.switch_mode = AnimationNodeStateMachineTransition.SWITCH_MODE_IMMEDIATE
					root.add_transition(states[i], states[j], transition)
	else:
		# Custom transitions
		for trans in transitions:
			var transition = AnimationNodeStateMachineTransition.new()
			if trans.has("mode"):
				transition.switch_mode = trans["mode"]
			root.add_transition(trans["from"], trans["to"], transition)
	
	# Set start node
	if not states.is_empty():
		root.start_node = states[0]
	
	anim_tree.root_node = root
	return anim_tree

# Create a custom blend-based tree for complex animation blending
static func create_blend_tree(
	animation_player: AnimationPlayer,
	anims_dict: Dictionary
) -> AnimationTree:
	# anims_dict format: { "animation_name": Vector2(blend_x, blend_y) }
	var anim_tree = AnimationTree.new()
	anim_tree.name = "AnimationTree"
	anim_tree.anim_player = animation_player.get_path()
	
	var blend_tree = AnimationNodeBlendTree.new()
	
	# Add animations as inputs
	for anim_name in anims_dict.keys():
		if animation_player.has_animation(anim_name):
			var anim_node = AnimationNodeAnimation.new()
			anim_node.animation = anim_name
			blend_tree.add_child_node(anim_name, anim_node)
	
	# Create main output
	var blend_node = AnimationNodeBlend2.new()
	blend_tree.add_child_node("blend", blend_node)
	blend_tree.connect_node("blend", 0, anims_dict.keys()[0])
	if anims_dict.size() > 1:
		blend_tree.connect_node("blend", 1, anims_dict.keys()[1])
	
	anim_tree.root_node = blend_tree
	return anim_tree

# Helper to enumerate loaded animations from AnimationPlayer
static func get_available_animations(animation_player: AnimationPlayer) -> Array[String]:
	var anims: Array[String] = []
	var lib = animation_player.get_animation_library("")
	if lib:
		anims = lib.get_animation_list()
	return anims

# Configure animation tree parameters programmatically
static func setup_parameters(
	anim_tree: AnimationTree,
	parameters: Dictionary
) -> void:
	for param_path in parameters.keys():
		var value = parameters[param_path]
		anim_tree.set("parameters/" + param_path, value)
