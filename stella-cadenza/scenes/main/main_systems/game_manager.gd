extends Node2D

@export var player : Player
@export var first_level_to_load : String = "1-1"
@export var pause_menu : Node

var force_paused : bool = false


func _ready():
	SignalBus.ForcePauseGame.connect(force_pause)
	SignalBus.ResetPlayerLocation.connect(reset_player_location)
	SignalBus.SetPlayerLocation.connect(set_player_location)
	await get_tree().create_timer(.1).timeout
	SignalBus.LoadLevel.emit(first_level_to_load)


func force_pause(pause : bool):
	# print("force pause: ", pause)
	Main.paused = pause
	force_paused = pause

func reset_player_location():
	if player:
		player.position = Vector2.ZERO
	SignalBus.ConfirmSetPlayerLocation.emit()

func set_player_location(spawn : Node2D):
	if player:
		player.velocity = Vector2.ZERO
		player.global_position = spawn.global_position
	SignalBus.ConfirmSetPlayerLocation.emit()


func toggle_pause():
	if not Main.paused:
		# print("paused")
		Main.paused = true
		if pause_menu:
			pause_menu.visible = true
		# OnPause.emit()
		# Engine.time_scale = 0
		# print(Engine.physics_ticks_per_second)
		# Engine.physics_ticks_per_second = 0
	else:
		# print("unpaused")
		Main.paused = false
		# OnPause.emit()
		# Engine.time_scale = 1
		# Engine.physics_ticks_per_second = 60


func _physics_process(_delta: float) -> void:
	# print("Pause State: ", Main.paused)
	if Main.paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not force_paused:
		toggle_pause()
