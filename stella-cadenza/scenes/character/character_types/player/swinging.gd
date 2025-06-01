extends State

@export var char_sprite : AnimatedSprite2D
@export var swing_sprite : AnimatedSprite2D
@export var chara : Character
@export var swing_attack : Swing_Attack
@export var swing_hitbox : Hitbox
@export var attack_slow : float
var original_velocity : float

func _ready() -> void:
	swing_attack.StartAttack.connect(start_swing_attack)
	swing_attack.StopAttack.connect(stop_swing_animation)

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta : float):
	pass

func start_swing_attack():
	start_swing_animation()
	original_velocity = chara.max_velocity
	chara.max_velocity = original_velocity*attack_slow

func start_swing_animation():
	swing_sprite.visible = true
	if chara.facing == 0:
		swing_hitbox.rotation = 0
		char_sprite.play("swing up")
		swing_sprite.play("swing up")
	elif chara.facing == 1:
		swing_hitbox.rotation = 90
		char_sprite.play("swing right")
		swing_sprite.play("swing right")
	elif chara.facing == 2:
		swing_hitbox.rotation = 180
		char_sprite.play("swing down")
		swing_sprite.play("swing down")
	elif chara.facing == 3:
		swing_hitbox.rotation = -90
		char_sprite.play("swing left")
		swing_sprite.play("swing left")
	# print(swing_hitbox.rotation)



func stop_swing_animation():
	swing_sprite.visible = false
	chara.max_velocity = original_velocity
	Transitioned.emit(self, "Idle")
