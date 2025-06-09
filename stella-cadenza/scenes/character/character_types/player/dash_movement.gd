extends Node

@export var player : Player
@export var dash_timer : Timer
@export var invincibility_timer : Timer
@export var gets_dash_invinvibility : bool = true

signal StartDash

func _physics_process(_delta: float) -> void:
	if Main.paused:
		return
	# print("hi")
	# print(dash_timer.time_left)
	if dash_timer.time_left <= 0.0:
		if player.can_dash and player.can_move:
			# print("I can dash")
			if Input.is_action_just_pressed("dash"):
				print("dashing")
				dash_timer.start()
				StartDash.emit()
				if gets_dash_invinvibility:
					start_invincibility()
				player.velocity = player.direction * player.dash_velocity
				player.move_and_slide()

func start_invincibility():
	player.invincible = true
	invincibility_timer.start()


func _on_invincibility_timer_timeout() -> void:
	player.invincible = false
