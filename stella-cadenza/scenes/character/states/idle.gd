extends State
@export var chara : CharacterBody2D

func Enter():
	print("I, ", get_parent().get_parent().name, ", am idle")

func Exit():
	pass

func Update(_delta: float):
	# print("moving at (", chara.velocity.x, ", ", chara.velocity.y, ")")
	if chara.velocity:
		print("I, ", get_parent().get_parent().name, ", am no longer idle")
		Transitioned.emit(self, "Moving")

func Physics_Update(_delta : float):
	pass
