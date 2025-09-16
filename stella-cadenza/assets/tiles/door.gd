class_name Door
extends Area2D

@export var level : String = "none"
@export var active : bool = true
@export var blocker: CollisionShape2D
@export var specific_exit : bool = false
@export var exit_coords : Vector2
@export var wait_for_specific_dialogue : bool = false
@export var dialogue : Dialogue_Interact


var dialogue_interacted_with : bool = false

func _ready():
	blocker.set_deferred("disabled", false)
	SignalBus.JustUnblocked.connect(on_unblock)
	if wait_for_specific_dialogue and dialogue:
		dialogue.DialogueOver.connect(just_interacted_with_dialogue)


func just_interacted_with_dialogue():
	dialogue_interacted_with = true

func on_unblock():
	# print("just unblocked")
	blocker.set_deferred("disabled", true)





func _on_body_entered(body:Node2D) -> void:
	if active:
		if wait_for_specific_dialogue and not dialogue_interacted_with:
			# print("dia not finished")
			return
		var player : Player = body as Player
		# print("something at door")
		if player:
			active = false
			# print("DOOR FOUND PLAYER")
			if not player.can_walk_through_door:
				# print("PLAYER CANNOT WALK THROUGH DOOR")
				active = true
				return
			# print("player going through!")
			if level != "none":
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
