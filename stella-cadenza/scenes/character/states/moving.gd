extends State
@export var chara : CharacterBody2D
@export var sprite : AnimatedSprite2D

func Enter():
	print("I am moving")

func Exit():
	pass

func Update(_delta: float):
	# print("moving at (", chara.velocity.x, ", ", chara.velocity.y, ")")
	if chara.velocity.y == 0.0:
		if chara.velocity.x == 0.0:
			sprite.play("idle")
			Transitioned.emit(self, "Idle")
			return
		if chara.velocity.x < 0:
			sprite.play("moving left")
		else:
			sprite.play("moving right")
	else:
		if chara.velocity.y < 0:
			sprite.play("moving up")
		else:
			sprite.play("moving down")
	

func Physics_Update(_delta : float):
	pass