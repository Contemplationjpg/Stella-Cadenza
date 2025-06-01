class_name Character
extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var base_velocity : float = 300
@export var stop_velocity : float = 300.0
@export var base_stats : stats
@export var debug : Label
@export var can_move : bool = true
@export var can_take_damage : bool = true
@export var invincible : bool = false
var facing : int
enum directions {up, right, down, left}
var direction: Vector2
@onready var current_health = base_stats.max_health

func _ready() -> void:
	debug.text = "health: " + str(current_health)


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
		


func update_movement():
	if direction:
		velocity = direction * base_velocity
		if direction.x != 0 and direction.y != 0:
			velocity *= 0.71
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stop_velocity)


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


