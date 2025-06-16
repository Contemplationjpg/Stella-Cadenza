class_name Swing_Attack
extends Node2D

@export var chara : Character
@export var swing_hitbox : Hitbox
@export var sprite : AnimatedSprite2D
@export var timer : Timer
@export var state_machine : State_Machine
@export var active_time : float = 0.2
@export var attack_slow : float = 0.5
var can_attack : bool = false
var attacking : bool = false
var original_velocity : float

signal StartAttack
signal StopAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true
	SignalBus.EvenBeat.connect(got_even_beat)
	SignalBus.OddBeat.connect(got_odd_beat)

func got_odd_beat():
	print("odd")

func got_even_beat():
	print("even")


func _process(_delta: float) -> void:
	if Main.paused:
		return
	# print(timer.time_left)
	if can_attack:
		# print("can attack")
		if Input.is_action_just_pressed("attack") and not attacking and timer.time_left <=0.0:
			# print("attacking")
			original_velocity = chara.max_velocity
			chara.max_velocity = original_velocity*attack_slow
			attacking = true
			state_machine.force_change_state("Swinging")
			StartAttack.emit()
			can_attack = false
			sprite.visible = true
			swing_hitbox.change_active(true)
			await get_tree().create_timer(active_time).timeout
			swing_hitbox.change_active(false)
			sprite.visible = false
			while Input.is_action_pressed("attack"):
				StartAttack.emit()
				sprite.visible = true
				swing_hitbox.change_active(true)
				timer.start()
				await get_tree().create_timer(active_time).timeout
				swing_hitbox.change_active(false)
				sprite.visible = false
			attacking = false
			timer.start()
			chara.max_velocity = original_velocity
			StopAttack.emit()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
