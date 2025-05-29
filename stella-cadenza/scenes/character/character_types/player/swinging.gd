extends State

@export var char_sprite : AnimatedSprite2D
@export var swing_sprite : AnimatedSprite2D
@export var chara : Character
@export var swing_attack : Swing_Attack

func _ready() -> void:
	swing_attack.StartAttack.connect(start_swing_animation)
	swing_attack.StopAttack.connect(stop_swing_animation)

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta : float):
	pass

func start_swing_animation():
	if chara.velocity.y == 0.0:
		if chara.velocity.x == 0.0:
			char_sprite.play("swing down")
			swing_sprite.play("swing")
		elif chara.velocity.x < 0:
			char_sprite.play("swing left")
			swing_sprite.play("swing")
		else:
			char_sprite.play("swing right")
			swing_sprite.play("swing")
	else:
		if chara.velocity.y < 0:
			char_sprite.play("swing up")
			swing_sprite.play("swing")
		else:
			char_sprite.play("swing down")
			swing_sprite.play("swing")

func stop_swing_animation():
	Transitioned.emit(self, "Idle")
