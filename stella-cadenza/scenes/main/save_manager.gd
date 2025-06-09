class_name Save_Manager
extends Node

@export var player : Player

var SAVE_FOLDER_PATH = "user://saves"


var default_save := {
	"saveNumber" : 0,
	"playerName" : "Maid",
	"version" : Main.get_version(),
	"posX" : 0,
	"posY" : 0
	}

var save_dict := {
	"saveNumber" : 0,
	"playerName" : "em",
	"version" : 1.0,
	"posX" : 0,
	"posY" : 0
	}

func save():
	return save_dict

func save_game(saveSlot:int):
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER_PATH):
		var save_folder = DirAccess.open("user://")
		save_folder.make_dir("saves")
		print("creating save directory")
	var path = (SAVE_FOLDER_PATH + "/save%d.save" % saveSlot)
	print("saving to: " + path)
	save_dict["saveNumber"] = saveSlot 
	save_dict["posX"] = player.global_position.x
	save_dict["posY"] = player.global_position.y
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(save()) #stores dictionary, save_dict, into a json file
	save_file.store_line(json_string)  #stores the json file info into user://saves/save#.save
	
func load_game(saveSlot : int) -> void:
	var path = (SAVE_FOLDER_PATH + "/save%d.save" % saveSlot)
	if not FileAccess.file_exists(path):
		return
	var save_file = FileAccess.open(path,FileAccess.READ)
	var node_data
	while save_file.get_position() < save_file.get_length(): #reads all lines of the json files if somehow more than 1 line
		var json_string = save_file.get_line() 
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		node_data = json.get_data() 
	save_dict = node_data
	print(node_data)
	Main.load_save(save_dict)
	
func readSaveData() -> void:
	print(save())
	
func load_player_position():
	if (player != null and save_dict.get("posX") != null and save_dict.get("posY") != null):
		player.global_position = Vector2(save_dict.get("posX"), save_dict.get("posY"))
	else:
		"no player or position to move to"	
