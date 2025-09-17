extends State
@export var chara : Player
@export var sprite : AnimatedSprite2D

func Enter():
	# print("I am moving")
	pass

func Exit():
	pass

func Update(_delta: float):
	# print("moving at (", chara.velocity.x, ", ", chara.velocity.y, ")")
	if chara.is_secondary_attacking:
		Transitioned.emit(self, "Shockwave")
		return
	if chara.is_primary_attacking:
		Transitioned.emit(self, "Swinging")
		return
	if chara.velocity.y == 0.0 and chara.velocity.x == 0.0:
			Transitioned.emit(self, "Idle")
			return
	if chara.facing == 0:
		sprite.play("moving up")
	elif chara.facing == 1:
			sprite.play("moving right")
	elif chara.facing == 2:
			sprite.play("moving down")
	elif chara.facing == 3:
			sprite.play("moving left")

func Physics_Update(_delta : float):
	pass