class_name Door
extends Area2D

@export var level : String = "none"
@export var active : bool = true

func _on_body_entered(body:Node2D) -> void:
	if active:
		var player : Player = body as Player
		print("something at door")
		if player:
			print("DOOR FOUND PLAYER")
			if not player.can_walk_through_door:
				print("PLAYER CANNOT WALK THROUGH DOOR")
				return
			if level != "none":
				active = false
				SignalBus.LoadLevel.emit(level)
			else:
				print("door level not set")
		else:
			print("NOT PLAYER AT DOOR")
	else:
		print("door not active")
