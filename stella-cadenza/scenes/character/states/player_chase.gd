extends State
@export var chara : Enemy
@export var sprite : AnimatedSprite2D

func _ready():
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	# print("moving at (", chara.velocity.x, ", ", chara.velocity.y, ")")
	if chara.velocity.y == 0.0 and chara.velocity.x == 0.0:
		Transitioned.emit(self, "Idle")
		return
	if !chara.chasing_player:
		Transitioned.emit(self, "Moving")
		return
	if chara.facing == 0:
		sprite.play("chase up")
	elif chara.facing == 1:
			sprite.play("chase right")
	elif chara.facing == 2:
			sprite.play("chase down")
	elif chara.facing == 3:
			sprite.play("chase left")



func Physics_Update(_delta : float):
	pass
