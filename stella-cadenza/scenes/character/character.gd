class_name Character
extends CharacterBody2D

@export var is_player : bool = false
@export var max_speed : float = 300.0
@export var stop_speed : float = 300.0
@export var base_stats : stats
@export var debug : Label
var direction: Vector2
@onready var current_health = base_stats.max_health

func _ready() -> void:
	debug.text = "health: " + str(current_health)

func _physics_process(_delta: float) -> void:
	if is_player:
		get_input()
	else:
		direction = Vector2.ZERO

	update_movement()
	# prints(velocity)
	move_and_slide()

func update_movement():
	if direction:
		velocity = direction * max_speed
		if direction.x != 0 and direction.y != 0:
			velocity *= 0.71
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stop_speed)

func get_input():
	direction.x = Input.get_axis("left", "right")
	# prints("x:",direction.x)
	direction.y = Input.get_axis("up", "down")
	# prints("y:",direction.y)



func change_health(change:int) -> int:
	var new = current_health + change
	var out = change
	if new > base_stats.max_health:
		out = base_stats.max_health - current_health
		current_health = base_stats.max_health
	elif new < 0:
		out = current_health
		current_health = 0
	else:
		current_health += change
	debug.text = "health: " + str(current_health)
	return out

func die():
	print(name, " dying!")
	queue_free()

func death_check():
	if current_health <= 0:
		die()

func deal_damage(damage:int) -> int:
	return change_health(-damage)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	# print("area ", area.get_parent().name, "'s ", area.name ," entered")
	var hitbox = area as Hitbox
	if not hitbox:
		# print ("not hitbox")
		return
	# else:
		# print("IS a hitbox that does ", hitbox.damage, " damage!")
		# if hitbox.active:
			# print("is active")
		# else:
			# print("is not active")

	if is_player:
		if hitbox.can_hit_player:
			deal_damage(hitbox.damage)
			# hitbox.change_active(false)
			if hitbox.disable_on_hit:
				hitbox.change_active(false)
			print(self.name, " new health:", current_health)
		# elif not hitbox.can_hit_player:
				# print("hitbox cannot hit player")
	
	elif not is_player:
		if hitbox.can_hit_enemy:
			deal_damage(hitbox.damage)
			# hitbox.change_active(false)
			if hitbox.disable_on_hit:
				hitbox.change_active(false)
			print(self.name, " new health:", current_health)
			death_check()
		# elif not hitbox.can_hit_enemy:
			# print("hitbox cannot hit enemy")
	
