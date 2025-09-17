class_name ArcherEnemy
extends Character

var player_chara : Player
@export var projectile : ArcherProjectile
@export var chases_player : bool = true
@export var aims_at_player : bool = true
@export var aim_time_before_shooting : float = 2.0
@export var time_before_refiring : float = 5.0
@export var body_hitbox : Hitbox
@export var player_looker : Node2D
var chasing_player = false
var aiming = false
var shooting = false

var time_aiming : float = 0.0

signal PlayerDetected
signal PlayerUndetected

signal JustShooting

func _process(_delta: float) -> void:
	# print(time_aiming)
	# if chasing_player:
		# print("I MUST CHASE")
		# print(direction)
	# else:
		# print("meh")
	pass	
	
func update_facing(): 
	if direction.y <= -0.5:
		if direction.x <= 0.5 and direction.x >= -0.5:
			facing = directions.up
	elif direction.y >= 0.5:
		if direction.x <= 0.5 and direction.x >= -0.5:
			facing = directions.down
	else:
		if direction.x > 0.5:
			facing = directions.right
		elif direction.x < -0.5:
			facing = directions.left
	# print(facing)


func _physics_process(delta: float) -> void:
	if player_chara:
		player_looker.look_at(player_chara.global_position)	

	body_hitbox.knockback_dir = direction

	if aiming and not shooting:
		time_aiming += delta
		if time_aiming > aim_time_before_shooting and not projectile.flying:
			JustShooting.emit()
			shooting = true
			await get_tree().create_timer(time_before_refiring).timeout
			shooting = false
	else:
		time_aiming = 0


	update_facing()
	update_movement(delta)
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	# print("area ", area.get_parent().name, "'s ", area.name ," entered")
	var hitbox = area as Hitbox
	if not hitbox or invincible:
		# print ("not hitbox")
		return
		
	if hitbox.can_hit_enemy:
		deal_damage(hitbox.damage)
		# hitbox.change_active(false)
		if hitbox.disable_on_hit:
			hitbox.change_active(false)
		# print(self.name, " new health:", current_health)
		death_check()
	# elif not hitbox.can_hit_enemy:
		# print("hitbox cannot hit enemy")

func _on_player_detection_range_body_exited(body:Node2D) -> void:
	var player = body as Player
	if player:
		player_chara = null
		PlayerUndetected.emit()
		if chases_player:
			chasing_player = false
		if aims_at_player:
			aiming = false
		print("player exited!")
		print("aiming: ", aiming)

func _on_player_detection_range_body_entered(body:Node2D) -> void:
	var player = body as Player
	if player:
		player_chara = player
		PlayerDetected.emit()
		if chases_player:
			chasing_player = true
		if aims_at_player:
			aiming = true
		print("player entered!")
		print("aiming: ", aiming)
