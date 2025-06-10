class_name Player
extends Character

@export var can_dash : bool = true
@export var dash_velocity : float = 3000
@export var mouse_looker : Node2D

@export var gets_hit_frozen : bool
@export var hit_freeze_time : float = 0.1
@export var gets_hit_invuln : bool = true
@export var hit_invuln_time : float = 1.0 

var in_hit_invuln : bool = false



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
	if Main.paused:
		return
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

	if Main.paused:
		return

	mouse_looker.look_at(get_global_mouse_position())

	var angle = (int)(mouse_looker.rotation_degrees + 180)%360
	# print(angle)

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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if not hitbox:
		# print ("not hitbox")
		return
	else:
		get_hit(hitbox)

	
func get_hit(hitbox : Hitbox):
	if not can_take_damage or invincible or in_hit_invuln:
		# print("INVINCIBLE")
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

		# print("player pos: ", global_position.x, ", ", global_position.y)
		# print("hitbox pos: ", hitbox.global_position.x, ", ", hitbox.global_position.y)
		
		var knockback : Vector2

		knockback = global_position - hitbox.global_position

		var new_velocity = knockback * hitbox.knockback 

		# var hitbox_collision = hitbox.get_child(0) as CollisionShape2D

		# var shape_size = 0

		# if hitbox.is_square:
		# 	if hitbox_collision.shape.size.x >= hitbox_collision.shape.size.y:
		# 		shape_size = hitbox_collision.shape.size.x
		# 	else:
		# 		shape_size = hitbox_collision.shape.size.y
		# elif hitbox.is_circle:
		# 	shape_size = hitbox_collision.shape.radius

		# # print(shape_size) 

		# if new_velocity.x < shape_size/2:
		# 	new_velocity.x = shape_size/2
		# if new_velocity.y < shape_size/2:
		# 	new_velocity.y = shape_size/2

		# print(new_velocity)


		velocity = new_velocity

		if gets_hit_frozen:
			can_move = false
			await get_tree().create_timer(hit_freeze_time).timeout
			can_move = true

		if gets_hit_invuln:
			in_hit_invuln = true
			sprite.self_modulate.a = 0.5
			await get_tree().create_timer(hit_invuln_time).timeout
			sprite.self_modulate.a = 1
			in_hit_invuln = false
		
