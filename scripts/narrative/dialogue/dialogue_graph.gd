# dialogue_graph.gd
extends Resource
class_name DialogueGraph

## A complete conversation tree with multiple branching paths.

@export var graph_id: String = ""
@export var speaker_name: String = ""  # Main NPC for this conversation
@export var speaker_portrait: Texture2D  # NPC portrait
@export var nodes: Array[DialogueLine] = []  # All dialogue nodes in this graph
@export var start_node_id: String = ""  # The first node to display

## Find a dialogue node by ID.
func get_node_by_id(node_id: String) -> DialogueLine:
	for node in nodes:
		if node.node_id == node_id:
			return node
	push_error("DialogueGraph: No node found with ID '%s'" % node_id)
	return null

## Get the starting node.
func get_start_node() -> DialogueLine:
	return get_node_by_id(start_node_id)

## Validate the entire graph for missing node references.
func validate() -> bool:
	if start_node_id.is_empty():
		push_error("DialogueGraph: No start_node_id set")
		return false
	
	for node in nodes:
		# Check if auto-advance target exists
		if not node.next_line_id.is_empty():
			if get_node_by_id(node.next_line_id) == null:
				push_error("DialogueGraph: Node '%s' references missing next_line_id '%s'" % [node.node_id, node.next_line_id])
				return false
		
		# Check if choice targets exist
		for choice in node.choices:
			if choice.next_node_id.is_empty():
				push_warning("DialogueGraph: Choice in node '%s' has no next_node_id" % node.node_id)
			elif get_node_by_id(choice.next_node_id) == null:
				push_error("DialogueGraph: Choice in node '%s' references missing node '%s'" % [node.node_id, choice.next_node_id])
				return false
	
	return true
