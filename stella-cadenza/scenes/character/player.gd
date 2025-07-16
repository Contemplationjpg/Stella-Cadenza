class_name Player
extends Character

@export var can_dash : bool = true
@export var dash_velocity : float = 3000
@export var mouse_looker : Node2D

@export var gets_hit_frozen : bool
@export var hit_freeze_time : float = 0.1
@export var gets_hit_invuln : bool = true
@export var hit_invuln_time : float = 1.0 
@export var knockback_traction : float = 20
@export var can_walk_through_door: bool = true

var in_hit_invuln : bool = false
var in_hit_freeze : bool = false

func _ready():
	SignalBus.LockPlayerSceneTransition.connect(lock_player_scene_transition)
	SignalBus.UnlockPlayerSceneTransition.connect(unlock_player_scene_transition)

func lock_player_scene_transition():
	can_walk_through_door = false
	can_move = false
	can_take_damage = false

func unlock_player_scene_transition():
	can_walk_through_door = true
	can_move = true
	can_take_damage = true


func _physics_process(delta: float) -> void:
	if can_move:
		get_input()
	else:
		direction = Vector2.ZERO

	print(direction)
	update_movement(delta)
	update_facing_mouse()
	# prints(velocity)
	move_and_slide()
	# print(velocity.x, ", ", velocity.y)

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

		if hitbox.knockback != 0 and hitbox.does_knockback:
			var new_velocity = hitbox.knockback_dir * hitbox.knockback 
			# print(new_velocity)
			velocity = new_velocity

		if gets_hit_frozen:
			hit_freeze()
		if gets_hit_invuln:
			hit_invul()			


func hit_freeze():
	can_move = false
	await get_tree().create_timer(hit_freeze_time).timeout
	can_move = true



func hit_invul():
	in_hit_invuln = true
	sprite.self_modulate.a = 0.5
	await get_tree().create_timer(hit_invuln_time).timeout
	sprite.self_modulate.a = 1
	in_hit_invuln = false
		
