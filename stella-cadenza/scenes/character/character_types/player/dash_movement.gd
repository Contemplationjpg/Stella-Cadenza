class_name Dash
extends Node

@export var player : Player
@export var manual_dash_cooldown : float = 0.8
@export var invincibility_timer : Timer
@export var gets_dash_invinvibility : bool = true
@export var slide_window : float = 0.5

var manual_dash_timer : float = 0

signal StartDash
signal EndDash

func _physics_process(delta: float) -> void:
	if Main.paused:
		return
	if manual_dash_cooldown < manual_dash_cooldown + 1:
		manual_dash_timer+=delta
	# print("hi")
	# print(dash_timer.time_left)
	if manual_dash_timer >= manual_dash_cooldown:
		if player.can_dash and player.can_move:
			# print("I can dash")
			if Input.is_action_just_pressed("dash"):
				# print("dashing")
				manual_dash_timer = 0
				# if gets_dash_invinvibility:
				# 	start_invincibility()
				dash()

func start_invincibility():
	player.invincible = true
	invincibility_timer.start()


func _on_invincibility_timer_timeout() -> void:
	player.invincible = false


func dash():
	StartDash.emit()
	if player.direction.x != 0 and player.direction.y != 0:
		player.velocity = player.direction * player.dash_velocity * 0.71
	else:
		player.velocity = player.direction * player.dash_velocity
	player.move_and_slide()
	await get_tree().create_timer(slide_window).timeout
	EndDash.emit()