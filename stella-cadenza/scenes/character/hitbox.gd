class_name Hitbox
extends Area2D

@export var damage : int = 10
@export var can_hit_player : bool = false
@export var can_hit_enemy : bool = false
@export var disable_on_hit : bool = false

func toggle_player_hit()->bool:
    can_hit_player = not can_hit_player
    return can_hit_player

func change_can_hit_player(change : bool):
    can_hit_player = change

func toggle_enemy_hit()->bool:
    can_hit_enemy = not can_hit_enemy
    return can_hit_enemy

func change_can_hit_enemy(change : bool):
    can_hit_enemy = change

func toggle_active()->bool:
    set_deferred("monitorable", not monitorable)
    return monitorable

func change_active(change : bool):
    set_deferred("monitorable", change)


# func _process(_delta: float) -> void:
# 	print(collision_layer)