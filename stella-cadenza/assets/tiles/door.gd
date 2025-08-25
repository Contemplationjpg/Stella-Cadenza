class_name Door
extends Area2D

@export var level : String = "none"
@export var active : bool = true
@export var specific_exit : bool = false
@export var exit_coords : Vector2

func _on_body_entered(body:Node2D) -> void:
	if active:
		var player : Player = body as Player
		# print("something at door")
		if player:
			# print("DOOR FOUND PLAYER")
			if not player.can_walk_through_door:
				# print("PLAYER CANNOT WALK THROUGH DOOR")
				return
			if level != "none":
				active = false
				if specific_exit:
					SignalBus.LoadLevelAtLocation.emit(level, exit_coords)
					return
				else:
					SignalBus.LoadLevel.emit(level)
	# 		else:
	# 			print("door level not set")
	# 	else:
	# 		print("NOT PLAYER AT DOOR")
	# else:
	# 	print("door not active")
