class_name Swing_Attack
extends Node2D

@export var swing_hitbox : Hitbox
@export var sprite : AnimatedSprite2D
@export var timer : Timer
@export var state_machine : State_Machine
var can_attack : bool = false

signal StartAttack
signal StopAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true

func _process(_delta: float) -> void:
	# print(timer.time_left)
	if can_attack:
		# print("can attack")
		if Input.is_action_just_pressed("attack") and timer.time_left <=0.0:
			# print("attacking")
			state_machine.force_change_state("Swinging")
			StartAttack.emit()
			can_attack = false
			sprite.visible = true
			swing_hitbox.change_active(true)
			timer.start()



func _on_attack_cooldown_timeout() -> void:
	swing_hitbox.change_active(false)
	sprite.visible = false
	can_attack = true
	StopAttack.emit()
