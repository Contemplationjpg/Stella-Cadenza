extends State

@export var char_sprite : AnimatedSprite2D
@export var shock_sprite : AnimatedSprite2D
@export var chara : Player
@export var shock_attack : Player_Secondary_Attack
@export var shock_hitbox : Hitbox

func _ready() -> void:
	shock_attack.StartAttack.connect(start_shock_attack)
	shock_attack.StopAttack.connect(stop_shock_animation)

func Enter():
	# print("SHOCKWAVE ANIMATION!!!!")
	pass

func Exit():
	pass

func Update(_delta: float):
	shock_animation()
	pass

func Physics_Update(_delta : float):
	pass

func do_shock_effect():
	shock_sprite.visible = true
	shock_sprite.play("shock right")

func shock_animation():
	# print("CHARACTER SHOCKING", chara.facing)
	char_sprite.play("shock down")
	if not chara.is_secondary_attacking:
		Transitioned.emit(self, "Idle")




func start_shock_attack():
	do_shock_effect()


func stop_shock_animation():
	shock_sprite.visible = false
