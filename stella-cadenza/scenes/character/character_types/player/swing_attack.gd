class_name Swing_Attack
extends Node2D

@export var swing_hitbox : Hitbox
@export var sprite : AnimatedSprite2D
@export var timer : Timer
@export var state_machine : State_Machine
@export var active_time : float = 0.2
var can_attack : bool = false
var attacking : bool = false

signal StartAttack
signal StopAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true

func _process(_delta: float) -> void:
	if Main.paused:
		return
	# print(timer.time_left)
	if can_attack:
		# print("can attack")
		if Input.is_action_just_pressed("attack") and not attacking and timer.time_left <=0.0:
			# print("attacking")
			attacking = true
			state_machine.force_change_state("Swinging")
			StartAttack.emit()
			can_attack = false
			sprite.visible = true
			swing_hitbox.change_active(true)
			timer.start()
			await get_tree().create_timer(active_time).timeout
			swing_hitbox.change_active(false)
			sprite.visible = false
			attacking = false
			StopAttack.emit()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
