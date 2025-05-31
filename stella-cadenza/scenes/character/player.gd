class_name Player
extends Character


func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	else:
		direction = Vector2.ZERO

	update_movement()
	update_facing()
	# prints(velocity)
	move_and_slide()


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
			print(self.name, " new health:", current_health)
		# elif not hitbox.can_hit_player:
				# print("hitbox cannot hit player")
	
