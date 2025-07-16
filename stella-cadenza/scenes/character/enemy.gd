class_name Enemy
extends Character

var player_chara : Player
@export var chases_player : bool = true
@export var chase_timer : Timer
@export var body_hitbox : Hitbox
@export var player_looker : Node2D
var chasing_player = false


signal PlayerDetected

signal PlayerUndetected

func _process(_delta: float) -> void:
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
	if can_move:
		if chase_timer.time_left <= 0.0:
			if chasing_player: 
				# print("attempting to chase")
				if player_chara:
					# var x_dir = player_chara.position.x - position.x
					# if x_dir > 0:
					# 	x_dir = 1
					# elif x_dir < 0:
					# 	x_dir = -1
					# else:
					# 	x_dir = 0
		
					# var y_dir = player_chara.position.y - position.y
					# if y_dir > 0:
					# 	y_dir = 1
					# elif y_dir < 0:
					# 	y_dir = -1
					# else:
					# 	y_dir = 0

					# direction = Vector2(x_dir, y_dir)
					direction = (player_chara.global_position - global_position).normalized()
					# print("player chase dir: ", direction)

				else:
					direction = Vector2.ZERO
					print("cannot find player")
			else:
				direction = Vector2.ZERO

			chase_timer.start()
	else:
		direction = Vector2.ZERO
	
	body_hitbox.knockback_dir = direction

	update_facing()
	update_movement(delta)
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	# print("area ", area.get_parent().name, "'s ", area.name ," entered")
	var hitbox = area as Hitbox
	if not hitbox:
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
		print("player exited!")

func _on_player_detection_range_body_entered(body:Node2D) -> void:
	var player = body as Player
	if player:
		player_chara = player
		PlayerDetected.emit()
		if chases_player:
			chasing_player = true
		print("player entered!")
