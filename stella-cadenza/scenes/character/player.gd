class_name Player
extends Character


@export var acceleration : float = 300
@export var max_velocity : float = 2000.0

var current_velocity : float

func _ready() -> void:
	current_velocity = base_velocity

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	else:
		direction = Vector2.ZERO

	update_movement()
	update_facing()
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

	
