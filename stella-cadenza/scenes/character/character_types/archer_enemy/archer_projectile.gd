class_name ArcherProjectile
extends Area2D

@export var archer : ArcherEnemy
@export var player_looker : Node2D
@export var projectile_speed : float = 1
@export var projectile_duration : float = 2

var flying : bool = false
var elapsed_time : float = 0
var target : Vector2 
var direction : Vector2

func _ready():
	archer.JustShooting.connect(shoot)

func _physics_process(delta):
	# print("flying: ", flying, "\n elapsed time: ", elapsed_time)
	if flying and elapsed_time <= projectile_duration:
		global_position += direction * projectile_speed * delta
		elapsed_time += delta
		return
	else:
		reset_projectile()

func shoot():
	if not flying:
		print("shooting projectile")
		visible = true
		if archer.player_chara:
			target = archer.player_chara.global_position #- Vector2(0,-10)
			direction = (target-global_position).normalized()
			elapsed_time = 0
			flying = true
	return

func reset_projectile():
	visible = false
	flying = false
	global_position = archer.global_position
	elapsed_time = projectile_duration+1


# func _on_hitbox_body_entered(body: Node2D) -> void:
	# reset_projectile()
	# var hitbox = body as Hitbox
	# if hitbox:
		# direction = hitbox.knockback_dir


func _on_body_entered(body:Node2D) -> void:
	print("Projectile Hit Something!")
	if body.name == "SwingHitbox":
		print("SWING!!!")
		print("old dir: ", direction)
		direction = (body as Hitbox).knockback_dir
		print("new dir: ", direction)
	elif body.name == "InvisTiles":
		return
	else:
		reset_projectile()