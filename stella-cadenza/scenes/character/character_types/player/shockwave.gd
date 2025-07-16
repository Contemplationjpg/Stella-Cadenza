extends State

@export var char_sprite : AnimatedSprite2D
@export var shock_sprite : AnimatedSprite2D
@export var chara : Character
@export var shock_attack : Player_Secondary_Attack
@export var shock_hitbox : Hitbox

func _ready() -> void:
	shock_attack.StartSecondaryAttack.connect(start_shock_attack)
	shock_attack.StopSecondaryAttack.connect(stop_shock_animation)

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta : float):
	pass

func start_shock_attack():
	start_shock_animation()

func start_shock_animation():
	shock_sprite.visible = true
	# shock_hitbox.rotation = 0
	# char_sprite.play("shock right")
	shock_sprite.play("shock right")
	if chara.facing == 0:
		# shock_hitbox.rotation = 0
		char_sprite.play("shock up")
		# shock_sprite.play("shock up")
	elif chara.facing == 1:
		# shock_hitbox.rotation = 90
		char_sprite.play("shock right")
		# shock_sprite.play("shock right")
	elif chara.facing == 2:
		# shock_hitbox.rotation = 180
		char_sprite.play("shock down")
		# shock_sprite.play("shock down")
	elif chara.facing == 3:
		# shock_hitbox.rotation = -90
		char_sprite.play("shock left")
		# shock_sprite.play("shock left")
	# print(shock_hitbox.rotation)
	shock_sprite.play("shock right")



func stop_shock_animation():
	shock_sprite.visible = false
	Transitioned.emit(self, "Idle")
