class_name Attack
extends Node2D

@export var player : Player
@export var hitbox : Hitbox
@export var sprite : AnimatedSprite2D
@export var timer : Timer
@export var active_time : float = 0.2
@export var attack_slow : float = 0.5
@export var attacks_on_odds : bool = true
@export var attacks_on_evens : bool = true
@export var primary_input : bool = true
@export var secondary_input : bool = false
@export var forgiveness : float = 0.15

var can_attack : bool = false
var attacking : bool = false
var should_be_attacking : bool = false
var original_velocity : float 
var in_forgiveness_timing: bool = false

signal StartAttack
signal StopAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true
	# original_velocity = chara.max_velocity
	SignalBus.EvenBeat.connect(got_even_beat)
	SignalBus.OddBeat.connect(got_odd_beat)

func got_odd_beat():
	if attacks_on_odds:
		# print("odd")
		# attack()
		return

func got_even_beat():
	if attacks_on_evens:
		# print("even")
		# attack()
		return

# func attack():
	# if not in_forgiveness_timing:
	# 	in_forgiveness_timing = true
	# 	wait_for_attack()
	# if should_be_attacking and in_forgiveness_timing:
	# 	in_forgiveness_timing = false
	# 	StartAttack.emit()
	# 	# can_attack = false
	# 	sprite.visible = true
	# 	hitbox.change_active(true)
	# 	await get_tree().create_timer(active_time).timeout
	# 	hitbox.change_active(false)
	# 	sprite.visible = false
	# 	StopAttack.emit()

# func wait_for_attack():
# 	await get_tree().create_timer(forgiveness).timeout
# 	if in_forgiveness_timing:
# 		in_forgiveness_timing = false	


func _process(_delta: float) -> void:
	if Main.paused:
		return
	# print(timer.time_left)

	if can_attack and player.can_attack: 
		if primary_input and Input.is_action_pressed("attack"):
			should_be_attacking = true
			# print("sba is true")
		elif secondary_input and Input.is_action_pressed("secondary"):
			should_be_attacking = true
			# print("sba is true")
		else:
			should_be_attacking = false
	else:
		should_be_attacking = false
		# print("sba is false")


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
