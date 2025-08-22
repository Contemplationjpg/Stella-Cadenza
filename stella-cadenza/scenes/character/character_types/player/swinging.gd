extends State

@export var char_sprite : AnimatedSprite2D
@export var swing_sprite : AnimatedSprite2D
@export var chara : Character
@export var swing_attack : Player_Primary_Attack
@export var swing_hitbox : Hitbox

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

func start_swing_animation():
	swing_sprite.visible = true
	swing_sprite.play("swing right")
	if chara.facing == 0:
		char_sprite.play("swing up")
	elif chara.facing == 1:
		char_sprite.play("swing right")
	elif chara.facing == 2:
		char_sprite.play("swing down")
	elif chara.facing == 3:
		char_sprite.play("swing left")
	# print(swing_hitbox.rotation)
	swing_sprite.play("swing right")



func stop_swing_animation():
	swing_sprite.visible = false
	Transitioned.emit(self, "Idle")
