extends CharacterBody2D


@export var SPEED = 300.0
var char_dir : Vector2

func _physics_process(delta: float) -> void:
	char_dir.x = Input.get_axis("left", "right")
	char_dir.y = Input.get_axis("up", "down")
	if char_dir:
		velocity = char_dir * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	move_and_slide()
