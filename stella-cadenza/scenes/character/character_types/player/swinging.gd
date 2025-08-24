extends State

@export var char_sprite : AnimatedSprite2D
@export var swing_sprite : AnimatedSprite2D
@export var chara : Player
@export var swing_attack : Player_Primary_Attack
@export var swing_hitbox : Hitbox

var should_be_swinging : bool = false

func _ready() -> void:
	swing_attack.StartAttack.connect(start_swing_attack)
	swing_attack.StopAttack.connect(stop_swing_animation)
	swing_attack.FullStopAttack.connect(full_stop_swing_animation)


func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	if chara.is_secondary_attacking:
		Transitioned.emit(self, "Shockwave")
		return
	swing_animation()

func Physics_Update(_delta : float):
	pass

func do_attack_effect():
	swing_sprite.visible = true
	swing_sprite.play("swing right")


func swing_animation():
	if should_be_swinging:
		# print("CHARACTER SWINGING", chara.facing)
		if chara.facing == 0:
			char_sprite.play("swing up")
		elif chara.facing == 1:
			char_sprite.play("swing right")
		elif chara.facing == 2:
			char_sprite.play("swing down")
		elif chara.facing == 3:
			char_sprite.play("swing left")

		# print(swing_hitbox.rotation)
		# swing_sprite.play("swing right")
	else:
		Transitioned.emit(self, "Idle")


func start_swing_attack():
	should_be_swinging = true
	do_attack_effect()

func stop_swing_animation():
	# print("swing over")
	swing_sprite.visible = false
	return

func full_stop_swing_animation():
	should_be_swinging = false
