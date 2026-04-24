class_name NodeEnemyStateMachine
extends Node

@export var initial_node_state : NodeState
@export var enemy : Enemy

var node_states : Dictionary = {}
var current_node_state : NodeState
var current_node_state_name : String
var parent_node_name : String

func _ready() -> void:
	parent_node_name = get_parent().name
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
			child.enemy = enemy
	
	if initial_node_state:
		initial_node_state._on_enter()
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()

	#print(parent_node_name, " - Current State: ", current_node_state_name)


func _process(delta : float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)


func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()
		


func transition_to(node_state_name : String) -> void:
	if node_state_name == current_node_state.name.to_lower():
		return
	
	var new_node_state:Node = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state._on_exit()
	
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()
	#print(parent_node_name, " - Current State: ", current_node_state_name)
