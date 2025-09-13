class_name Level_Loader
extends Node

@export var player : Player

var current_song : String = "none"

func _ready():
	SignalBus.LoadLevel.connect(load_level)
	SignalBus.LoadLevelAtLocation.connect(load_level_at_location)
	SignalBus.ConfirmSetPlayerLocation.connect(test)

func test():
	print("confirmed reset player location")

func load_level(level_name : String):
	var path : String = "res://scenes/levels/" + level_name + ".tscn"
	if ResourceLoader.exists(path):
		print("found level ", level_name)
		var level = ResourceLoader.load(path)
		SignalBus.FadeToBlack.emit()
		SignalBus.LockPlayerSceneTransition.emit()
		await SignalBus.FadeNotChanging
		# await get_tree().create_timer(.01).timeout
		var scene_instance = level.instantiate()
		var level_details = scene_instance.get_child(0) as LevelDetails
		print(level_details.name)
		if level_details.name == "LevelDetails":
			if level_details.is_player_spawn:
				player.global_position = level_details.global_position
			print(level_details.song_name)
			if level_details.song_name != "none" and level_details.song_name != current_song:
				current_song = level_details.song_name
				SignalBus.PlaySong.emit(current_song)
				# SignalBus.SetPlayerLocation.emit(player_spawn)
			player.can_attack = not level_details.disable_player_attack
			print("player can attack: ", player.can_attack)
		else:
			player.position = Vector2.ZERO
			# SignalBus.ResetPlayerLocation.emit()
		# await SignalBus.ConfirmSetPlayerLocation
		for n in get_children():
			remove_child(n)
			n.queue_free()
		add_child(scene_instance)
		SignalBus.UnlockPlayerSceneTransition.emit()
		await get_tree().create_timer(.25).timeout
		SignalBus.FadeFromBlack.emit()
	else:
		print_debug("Level Loader: cannot find level from path ", path)
		
func load_level_at_location(level_name : String, location : Vector2):
	var path : String = "res://scenes/levels/" + level_name + ".tscn"
	if ResourceLoader.exists(path):
		print("found level")
		var level = ResourceLoader.load(path)
		SignalBus.FadeToBlack.emit()
		SignalBus.LockPlayerSceneTransition.emit()
		await SignalBus.FadeNotChanging
		await get_tree().create_timer(.01).timeout
		var scene_instance = level.instantiate()
		player.position = location
		for n in get_children():
			remove_child(n)
			n.queue_free()
		add_child(scene_instance)
		SignalBus.UnlockPlayerSceneTransition.emit()
		SignalBus.FadeFromBlack.emit()
	else:
		print_debug("Level Loader: cannot find level from path ", path)
	
