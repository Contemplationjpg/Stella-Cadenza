extends Node

const VERSION_NUMBER = "0.0.1"

var current_save = 0
var health = 0
var save_data
var paused : bool = false
var doing_dialogue : bool = false

var volume : float = -10

func get_version():
	return VERSION_NUMBER

func load_save(save_load : Dictionary):
	save_data = save_load
	if save_data.get("saveNumber")!=null:
		current_save = save_data.get("saveNumber")
	else:
		current_save = 0
	print("loaded save to singleton")
