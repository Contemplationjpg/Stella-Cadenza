class_name Level_Loader
extends Node

@export var player : Player

func _ready():
	SignalBus.LoadLevel.connect(load_level)
	SignalBus.ConfirmResetPlayerLocation.connect(test)

func test():
	print("confirmed reset player location")

func load_level(level_name : String):
	var path : String = "res://scenes/levels/" + level_name + ".tscn"
	if ResourceLoader.exists(path):
		print("found level")
		var level = ResourceLoader.load(path)
		SignalBus.FadeToBlack.emit()
		SignalBus.LockPlayerSceneTransition.emit()
		await SignalBus.FadeNotChanging
		player.position = Vector2.ZERO
		await get_tree().create_timer(.01).timeout
		# SignalBus.ResetPlayerLocation.emit()
		# await SignalBus.ConfirmResetPlayerLocation
		var scene_instance = level.instantiate()
		for n in get_children():
			remove_child(n)
			n.queue_free()
		add_child(scene_instance)
		SignalBus.UnlockPlayerSceneTransition.emit()
		SignalBus.FadeFromBlack.emit()
	else:
		print_debug("Level Loader: cannot find level from path ", path)
	
	
