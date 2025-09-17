class_name Player
extends Character

@export var can_attack : bool = true
@export var can_dash : bool = true
@export var dash_velocity : float = 3000
@export var mouse_looker : Node2D
@export var health_bar : ProgressBar

@export var gets_hit_frozen : bool
@export var hit_freeze_time : float = 0.1
@export var gets_hit_invuln : bool = true
@export var hit_invuln_time : float = 1.0 
@export var knockback_traction : float = 20
@export var can_walk_through_door: bool = true
@export var stacks_needed : int = 3
@export var slide_stacks_needed : int = 2

@export var primary_attack : Attack
@export var secondary_attack : Attack
@export var dash : Dash
@export var slide_duration : float = 0.3
@export var slide_max_velo_bonus : float = 500
@export var slide_acceleration_bonus : float = 500

@export var stack_label : Label
@export var full_charge_sign : Sprite2D
@export var white_notes : Array[TextureRect]

var in_hit_invuln : bool = false
var in_hit_freeze : bool = false

var attack_stacks : int = 0
var special_meter : int = 0

var slide_stacks : int = 0

var in_dash_slide_window : bool = false
var in_secondary_slide_window : bool = false
var is_sliding : bool = false
var is_resliding : bool = false

var is_primary_attacking : bool = false
var is_secondary_attacking : bool = false

func _ready():
	SignalBus.LockPlayerSceneTransition.connect(lock_player_scene_transition)
	SignalBus.UnlockPlayerSceneTransition.connect(unlock_player_scene_transition)
	if primary_attack:
		# print("PLAYER CONNECTING START P")
		primary_attack.StartAttack.connect(on_primary_attack_start)
		# print("PLAYER CONNECTING END P")
		primary_attack.StopAttack.connect(on_primary_attack_end)
	if secondary_attack:
		# print("PLAYER CONNECTING START S")
		secondary_attack.StartAttack.connect(on_secondary_attack_start)
		# print("PLAYER CONNECTING END S")
		secondary_attack.StopAttack.connect(on_secondary_attack_end)
	if dash:
		dash.StartDash.connect(on_dash_start)
		dash.EndDash.connect(on_dash_end)
	if health_bar:
		HealthChanged.connect(update_health_bar)
		update_health_bar()
	if white_notes.size() > 0:
		primary_attack.ChangeStacks.connect(update_note_stacks)
		update_note_stacks()

	
func _process(_delta):
	if stack_label:
		stack_label.text = str(attack_stacks)
	
	# print(c_stop_velocity)


func _physics_process(delta: float) -> void:
	if can_move:
		get_input()
	else:
		direction = Vector2.ZERO

	# print(direction)
	update_movement(delta)
	update_facing_mouse()
	# prints(velocity)
	move_and_slide()
	# print(velocity.x, ", ", velocity.y)
	if is_sliding:
		if slide_stacks < secondary_attack.hitbox.already_hit_hurtboxes.size():
			slide_stacks = secondary_attack.hitbox.already_hit_hurtboxes.size()

func get_input():
	direction.x = Input.get_axis("left", "right")
	# prints("x:",direction.x)
	direction.y = Input.get_axis("up", "down")
	# prints("y:",direction.y)

func update_health_bar():
	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = base_stats.max_health
		health_bar.value = current_health

func update_note_stacks():
	# print("updating note stacks")
	if white_notes.size() > 0 and white_notes.size() == stacks_needed:
		# print(attack_stacks)
		if attack_stacks == 0:
			for i in white_notes:
				i.visible = false
		else:
			for i in white_notes.size():
				# print("doing ", i)
				if i <= attack_stacks-1:
					# print("vis")
					white_notes[i].visible = true
				else:
					# print("invis")
					white_notes[i].visible = false
	# else:
		# print("erm I can't update note stacks")
	if full_charge_sign:
		if attack_stacks >= stacks_needed:
			full_charge_sign.visible = true
		else:
			full_charge_sign.visible = false

func update_facing_mouse():

	if Main.paused:
		return

	if not is_primary_attacking:
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
		
func lock_player_scene_transition():
	can_walk_through_door = false
	can_move = false
	can_take_damage = false

func unlock_player_scene_transition():
	can_walk_through_door = true
	can_move = true
	can_take_damage = true


func on_primary_attack_start():
	# print("PLAYER START PRIMARY")
	is_primary_attacking = true
	return

func on_primary_attack_end():
	# print("PLAYER STOP PRIMARY")
	is_primary_attacking = false
	return

func on_secondary_attack_start():
	# print("PLAYER START SECONDARY")
	# if in_dash_slide_window and not is_sliding:
	# 	electric_slide()
	# else:
		# in_secondary_slide_window = true	
	
	in_secondary_slide_window = true
	is_secondary_attacking = true
	update_note_stacks()
	return

func on_secondary_attack_end():
	in_secondary_slide_window = false
	is_secondary_attacking = false
	# print("PLAYER STOP SECONDARY")
	
	return

func on_dash_start():
	# sprite.self_modulate.a = 0.5
	if in_secondary_slide_window and not is_sliding:
		dash.start_invincibility()
		electric_slide()
	# else:
	# 	in_dash_slide_window = true
	# print("PLAYER IS DASHING")
	return

func on_dash_end():
	# sprite.self_modulate.a = 1
	# in_dash_slide_window = false
	# print("PLAYER STOPPED DASHING")	
	return

func electric_slide():
	is_sliding = true
	slide_stacks = 0
	# print("SLIDING")
	c_stop_velocity = 0
	c_max_velocity = max_velocity + slide_max_velo_bonus
	c_acceleration = acceleration + slide_acceleration_bonus
	# print("max velo is:", max_velocity)
	# print("c max velo is:", c_max_velocity)
	await get_tree().create_timer(slide_duration).timeout
	c_stop_velocity = stop_velocity
	c_max_velocity = max_velocity
	c_acceleration = acceleration
	print("slide stacks: ", slide_stacks)
	if slide_stacks >= slide_stacks_needed:
		attack_stacks = stacks_needed
		change_health(10)
		dash.manual_dash_timer = dash.manual_dash_cooldown+1
	update_note_stacks()
	is_sliding = false
