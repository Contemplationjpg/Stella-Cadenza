class_name Character
extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var base_velocity : float = 300
@export var max_velocity : float = 2000.0
@export var stop_velocity : float = 300.0
@export var stop_velocity_still : float = 1500.0
@export var base_stats : stats
@export var acceleration : float = 300
@export var debug : Label
@export var can_move : bool = true
@export var can_take_damage : bool = true
@export var invincible : bool = false
var facing : int
enum directions {up, right, down, left}
var direction: Vector2
@onready var current_health = base_stats.max_health
@onready var c_stop_velocity = stop_velocity
@onready var c_max_velocity = max_velocity
@onready var c_acceleration = acceleration

var dead : bool = false

signal JustDied
signal HealthChanged

func _ready() -> void:
	if debug:
		debug.text = "health: " + str(current_health)
	# current_velocity = base_velocity


# func _physics_process(_delta: float) -> void:
	# update_facing()


func update_facing(): 
	if direction.y == 0.0:
		if direction.x == 0.0:
			return
		if direction.x < 0:
			facing = directions.left
		else:
			facing = directions.right
	elif direction.x == 0.0:
		if direction.y < 0:
			facing = directions.up
		else:
			facing = directions.down
	else:
		return
	# print(facing)

# func update_facing():
	
		


# # func update_movement():
# # 	if Main.paused:
# # 		return
# # 	if direction:
# # 		velocity = direction * current_velocity
# # 		if direction.x != 0 and direction.y != 0:
# # 			velocity *= 0.71
# # 	else:
# 		velocity = velocity.move_toward(Vector2.ZERO, stop_velocity)

func update_movement(delta : float):
	if Main.paused:
		return
	if can_move:
		if direction:
			if (direction.x > 0 and velocity.x < 0) or (direction.x < 0 and velocity.x > 0):
				# print("flipping x")
				velocity.x = -velocity.x
			if (direction.y > 0 and velocity.y < 0) or (direction.y < 0 and velocity.y > 0):
				# print("flipping y")
				velocity.y = -velocity.y
			if direction.x != 0 and direction.y != 0:
				# print("xydir")
				if (velocity.x >= 0 and velocity.x < c_max_velocity*.71) or (velocity.x < 0 and velocity.x > -c_max_velocity*.71):
					if (velocity.x >= 0 and velocity.x < base_velocity*.71) or (velocity.x < 0 and velocity.x > -base_velocity*.71):
						velocity.x = direction.x*base_velocity*.71
					velocity.x += direction.x*c_acceleration*delta
				if (velocity.y >= 0 and velocity.y < c_max_velocity*.71) or (velocity.y < 0 and velocity.y > -c_max_velocity*.71):
					if (velocity.y >= 0 and velocity.y < base_velocity*.71) or (velocity.y < 0 and velocity.y > -base_velocity*.71):
						velocity.y = direction.y*base_velocity*.71
					velocity.y += direction.y*c_acceleration*delta
				if (velocity.x >= 0 and velocity.x > c_max_velocity*.71) or (velocity.x < 0 and velocity.x < -c_max_velocity*.71):
					velocity = velocity.move_toward(Vector2(max_velocity*.71 * sign(velocity.x), velocity.y), c_stop_velocity)
				if (velocity.y >= 0 and velocity.y > c_max_velocity*.71) or (velocity.y < 0 and velocity.y < -c_max_velocity*.71):
					velocity = velocity.move_toward(Vector2(velocity.x, c_max_velocity*.71 * sign(velocity.y)), c_stop_velocity)
			elif direction.x != 0:
				# print("xdir")
				# if (direction.x > 0 and velocity.x < 0) or (direction.x < 0 and velocity.x > 0):
				# 	velocity.x = -velocity.x
				if (velocity.x >= 0 and velocity.x < c_max_velocity) or (velocity.x < 0 and velocity.x > -c_max_velocity):
					if (velocity.x >= 0 and velocity.x < base_velocity) or (velocity.x < 0 and velocity.x > -base_velocity):
						velocity.x = direction.x*base_velocity
					velocity.x += direction.x*c_acceleration*delta
				if (velocity.x >= 0 and velocity.x > c_max_velocity) or (velocity.x < 0 and velocity.x < -c_max_velocity):
					velocity = velocity.move_toward(Vector2(max_velocity * sign(velocity.x), 0), c_stop_velocity)
						
			elif direction.y != 0:
				# print("ydir")
				# if (direction.y > 0 and velocity.y < 0) or (direction.y < 0 and velocity.y > 0):
				# 	velocity.y = -velocity.y
				if (velocity.y >= 0 and velocity.y < c_max_velocity) or (velocity.y < 0 and velocity.y > -c_max_velocity):
					if (velocity.y >= 0 and velocity.y < base_velocity) or (velocity.y < 0 and velocity.y > -base_velocity):
						velocity.y = direction.y*base_velocity
					velocity.y += direction.y*c_acceleration*delta
				if (velocity.y >= 0 and velocity.y > c_max_velocity) or (velocity.y < 0 and velocity.y < -c_max_velocity):
					velocity = velocity.move_toward(Vector2(0, c_max_velocity * sign(velocity.y)), c_stop_velocity)
			# print("slowing")
			velocity = velocity.move_toward(Vector2.ZERO, c_stop_velocity)

		else:
			# print("slowing fast")
			# velocity = velocity.move_toward(Vector2.ZERO, stop_velocity_still)
			velocity = velocity.move_toward(Vector2.ZERO, c_stop_velocity)
		# print(velocity)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, c_stop_velocity)
			


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
	if debug:
		debug.text = "health: " + str(current_health)
	HealthChanged.emit()
	return out

func die():
	print(name, " dying!")
	dead = true
	JustDied.emit()
	queue_free()

func death_check():
	if current_health <= 0:
		die()

func deal_damage(damage:int) -> int:
	return change_health(-damage)
