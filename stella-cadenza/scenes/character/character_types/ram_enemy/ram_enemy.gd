class_name RamEnemy
extends Character

var player_chara : Player
@export var chases_player : bool = true
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
		# print("player exited!")

func _on_player_detection_range_body_entered(body:Node2D) -> void:
	var player = body as Player
	if player:
		player_chara = player
		PlayerDetected.emit()
		if chases_player:
			chasing_player = true
		# print("player entered!")
