class_name EnemyReq

extends SwitchTile

@export var sprite : AnimatedSprite2D

@export var switch_cooldown : float = 0.5

@export var required_enemies : Array[Character]


func update_sprite():
	if not sprite:
		return
	if powered:
		sprite.play("on")
	else:
		sprite.play("off")

func _ready():
	for i in required_enemies:
		i.JustDied.connect(update_enemy_req)		

func update_enemy_req():
	for i in required_enemies:
		if i:
			if not i.dead:
				print("found enemy: ", i.name)
				powered = false
				LeverHit.emit(false)
				return
	print("no enemies found")
	powered = true
	update_sprite()
	LeverHit.emit(true)
