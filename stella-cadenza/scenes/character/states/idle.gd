extends State
@export var chara : Character
@export var sprite : AnimatedSprite2D

func Enter():
	# print("I, ", get_parent().get_parent().name, ", am idle")
	if chara.facing == 0:
		sprite.play("idle up")
	if chara.facing == 1:
		sprite.play("idle right")
	if chara.facing == 2:
		sprite.play("idle down")
	if chara.facing == 3:
		sprite.play("idle left")

func Exit():
	pass

func Update(_delta: float):
	# print("moving at (", chara.velocity.x, ", ", chara.velocity.y, ")")
	if chara.velocity:
		# print("I, ", get_parent().get_parent().name, ", am no longer idle")
		Transitioned.emit(self, "Moving")

func Physics_Update(_delta : float):
	pass
