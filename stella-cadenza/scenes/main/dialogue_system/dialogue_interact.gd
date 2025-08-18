extends Area2D

@export var scene_name : String
@export var limited : bool = false
@export var force_interact : bool = false
@export var active : bool = true


var player_in_area : bool = false
var interacted_with : bool = false
var limit_mark : bool = false

func _ready():
	set_active(active)

func _process(_delta):
	if active:	
		if player_in_area and force_interact and not interacted_with and not Main.doing_dialogue:
			if limited and not limit_mark:
				SignalBus.display_dialogue.emit(scene_name)
				interacted_with = true
				limit_mark = true
			elif not limited:
				SignalBus.display_dialogue.emit(scene_name)
				interacted_with = true
				limit_mark = true
		elif player_in_area and not interacted_with and not Main.doing_dialogue:
			if limited and not limit_mark:
				if Input.is_action_just_pressed("yes"):
					SignalBus.display_dialogue.emit(scene_name)
					interacted_with = true
					limit_mark = true
			elif not limited:
				if Input.is_action_just_pressed("yes"):
					SignalBus.display_dialogue.emit(scene_name)
					interacted_with = true
					limit_mark = true

func set_active(new_active : bool):
	active = new_active
	set_deferred("monitorable",active)


func _on_body_entered(body:Node2D) -> void:
	var player = body as Player
	if player:
		# print("player entered dialogue box area")
		player_in_area = true
	# else:
	# 	print("not player")


func _on_body_exited(body:Node2D) -> void:
	var player = body as Player
	if player:
		# print("player exited dialogue box area")
		player_in_area = false
		interacted_with = false
	# else:
		# print("not player")
