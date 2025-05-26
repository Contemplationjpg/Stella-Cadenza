extends Node

@export var is_player : bool = false
@export var char_body : CharacterBody2D
@export var speed : float = 300.0
var direction: Vector2


func _physics_process(_delta: float) -> void:
    if is_player:
        get_input()
    else:
        direction = Vector2.ZERO

    update_movement()
    prints(char_body.velocity)

func update_movement():
    if direction:
        char_body.velocity = direction * speed
    else:
        char_body.velocity = char_body.velocity.move_toward(Vector2.ZERO, speed)
    
func get_input():
    direction.x = Input.get_axis("left", "right")
    prints("x:",direction.x)
    direction.y = Input.get_axis("up", "down")
    prints("y:",direction.y)