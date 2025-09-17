extends State
@export var chara : ArcherEnemy
@export var sprite : AnimatedSprite2D

func Enter():
	sprite.play("shooting")

func Exit():
	pass

func Update(delta: float):
	if not chara.shooting:
		Transitioned.emit(self, "Idle")

func Physics_Update(_delta : float):
	pass
