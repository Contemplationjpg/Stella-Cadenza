extends State
@export var chara : ArcherEnemy
@export var sprite : AnimatedSprite2D

func Enter():
	sprite.play("aiming")

func Exit():
	pass

func Update(delta: float):
	if chara.shooting:
		Transitioned.emit(self, "Shooting")
	elif not chara.aiming:
		Transitioned.emit(self, "Idle")

func Physics_Update(_delta : float):
	pass
