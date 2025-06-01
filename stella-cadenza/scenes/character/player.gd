class_name Player
extends Character


@export var acceleration : float = 300
@export var max_velocity : float = 2000.0
@export var mouse_looker : Node2D

var current_velocity : float

func _ready() -> void:
	current_velocity = base_velocity

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	else:
		direction = Vector2.ZERO

	update_movement()
	update_facing_mouse()
	# prints(velocity)
	move_and_slide()
	# print(velocity.x, ", ", velocity.y)

func update_movement():
	if direction:
		var velocity_increase = direction * acceleration
		if direction.x != 0 and direction.y != 0:
			velocity_increase *= 0.71
		velocity += velocity_increase

		if direction.x == 0 and direction.y != 0:
			velocity = velocity.move_toward(Vector2(0.0,velocity.y), stop_velocity)
		elif direction.x != 0 and direction.y == 0:
			velocity = velocity.move_toward(Vector2(velocity.x,0.0), stop_velocity)

		if direction.x != 0 and direction.y != 0:
			var target_x = velocity.x
			var target_y = velocity.y
			if velocity.x >= max_velocity*0.71:
				target_x = max_velocity*0.71
			if velocity.y >= max_velocity*0.71:
				target_y = max_velocity*0.71
			if velocity.x <= -max_velocity*0.71:
				target_x = -max_velocity*0.71
			if velocity.y <= -max_velocity*0.71:
				target_y = -max_velocity*0.71

			velocity = velocity.move_toward(Vector2(target_x,target_y),stop_velocity)
			
		else:
			var target_x = velocity.x
			var target_y = velocity.y
			if velocity.x >= max_velocity:
				target_x = max_velocity
			if velocity.y >= max_velocity:
				target_y = max_velocity
			if velocity.x <= -max_velocity:
				target_x = -max_velocity
			if velocity.y <= -max_velocity:
				target_y = -max_velocity

			velocity = velocity.move_toward(Vector2(target_x,target_y),stop_velocity)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, stop_velocity)

func get_input():
	direction.x = Input.get_axis("left", "right")
	# prints("x:",direction.x)
	direction.y = Input.get_axis("up", "down")
	# prints("y:",direction.y)

func update_facing_mouse():
	# var mouse = get_local_mouse_position()
	# print(mouse)
	# var facing_dir = mouse #- global_position
	# var angle = -rad_to_deg(get_angle_to(mouse)) 
	mouse_looker.look_at(get_global_mouse_position())

	# print(mouse_looker.rotation)

	# if mouse_looker.rotation >= 360:
	# 	mouse_looker.rotation = 0
	# elif mouse_looker.rotation <= 0:
	# 	mouse_looker.rotation = 0
	var angle = (int)(mouse_looker.rotation_degrees + 180)%360
	# print(angle)
	print(angle)

	# var angle = abs(atan(facing_dir.y-facing_dir.x))
	# print(angle)
	# if facing_dir.x >= 0:
	# 	if facing_dir.y <= 0:
	# 		# print("I")
	# 		pass
	# 	elif facing_dir.y > 0:
	# 		# print("VI")
	# 		angle = 360 - angle
	# elif facing_dir.x < 0:
	# 	if facing_dir.y <= 0:
	# 		# print("II")
	# 		angle = 180 - angle
	# 	elif facing_dir.y > 0:
	# 		angle = 180 + angle
	# 		# print("III")


	if angle >= 0:
		if angle <= 45 or angle > 315:
			facing = directions.left
		elif angle > 45 and angle <= 135:
			facing = directions.up
		elif angle > 135 and angle <= 225:
			facing = directions.right
		elif angle > 225 and angle <= 315:
			facing = directions.down
	if angle < 0:
		if angle >= -45 or angle < -315:
			facing = directions.left
		elif angle < -45 and angle >= -135:
			facing = directions.down
		elif angle < -135 and angle >= -225:
			facing = directions.right
		elif angle < -225 and angle >= -315:
			facing = directions.up


	# if angle <= 45 and angle > -45:
	# 	facing = directions.right
	# elif angle > 45 and angle <= 135:
	# 	facing = directions.up
	# elif angle > 135 and angle >= -135:
	# 	facing = directions.left
	# elif angle > -135 and angle <= -45:
	# 	facing = directions.down
	
	# print(angle, ", ", facing)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if not hitbox:
		# print ("not hitbox")
		return
	if hitbox.can_hit_player:
		deal_damage(hitbox.damage)
		# hitbox.change_active(false)
		if hitbox.disable_on_hit:
			hitbox.change_active(false)
		# print(self.name, " new health:", current_health)
	# elif not hitbox.can_hit_player:
		# print("hitbox cannot hit player")

		if hitbox.knockback == 0 or not hitbox.does_knockback:
			return

		var knockback_dir : Vector2
		if global_position.x > hitbox.position.x:
			knockback_dir.x = 1.0
		elif global_position.x == hitbox.position.x:
			knockback_dir.x = 0.0
		elif global_position.x < hitbox.position.x:
			knockback_dir.x = -1.0
		

		if global_position.y > hitbox.position.x:
			knockback_dir.y = 1.0
		elif global_position.y == hitbox.position.x:
			knockback_dir.y = 0.0
		elif global_position.y < hitbox.position.x:
			knockback_dir.y = -1.0

		print("player pos: ", global_position.x, ", ", global_position.y)
		print("hitbox pos: ", hitbox.global_position.x, ", ", hitbox.global_position.y)
		
		var knockback : Vector2

		knockback = global_position - hitbox.global_position

		velocity = knockback * hitbox.knockback

		print(knockback)

	
