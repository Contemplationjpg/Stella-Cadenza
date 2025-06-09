extends Node2D

var force_paused : bool = false

func _ready():
	SignalBus.ForcePauseGame.connect(force_pause)

func force_pause(pause : bool):
	# print("force pause: ", pause)
	Main.paused = pause
	force_paused = pause


func toggle_pause():
	if not Main.paused:
		# print("paused")
		Main.paused = true
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