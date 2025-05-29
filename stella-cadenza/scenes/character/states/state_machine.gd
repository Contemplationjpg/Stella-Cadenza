extends Node
class_name State_Machine

@export var default_state : State
@export var chara : CharacterBody2D
@export var debug : Label

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			print(child.name)
			child.Transitioned.connect(on_child_transition)
	print("loaded states: ", states.size())
	current_state = default_state
	default_state.Enter()
	debug.text = str(current_state.name)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func force_change_state(new_state_name : String):
	var new_state = states.get(new_state_name)
	if !new_state:
		print("what da heck")
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()

	current_state = new_state
	print(current_state.name)
	debug.text = str(current_state.name)


func on_child_transition(state, new_state_name : String):
	# print("on child transition ", state.name, " ", new_state_name)
	if state != current_state:
		return

	# print(states.get(new_state_name))
	var new_state = states.get(new_state_name)
	if !new_state:
		print("what da heck")
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()

	current_state = new_state
	print(current_state.name)
	debug.text = str(current_state.name)
