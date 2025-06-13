class_name Hitbox
extends Area2D

@export var damage : int = 10
@export var knockback : float = 5
@export var active : bool = true
@export var does_knockback : bool = true
@export var knockback_dir : Vector2 = Vector2(0,1)
@export var can_hit_player : bool = false
@export var can_hit_enemy : bool = false
@export var disable_on_hit : bool = false
@export var constant : bool = true
@export var constant_blink_time : float = 0.1
@export var is_square : bool = true
@export var is_circle : bool = false

func _ready() -> void:
    update_constant()

func constant_damage():
    while active and constant:
        # print("toggle")
        toggle_monitoriable()
        await get_tree().create_timer(constant_blink_time).timeout    
    

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
    active = not active
    set_deferred("monitorable", not monitorable)
    if active:
        update_constant()
    return monitorable

func change_active(change : bool):
    active = change
    set_deferred("monitorable", change)
    if active:
        update_constant()

func update_constant():
    if active and constant:
        constant_damage()

func toggle_monitoriable()-> bool:
    set_deferred("monitorable", not monitorable)
    return monitorable


func change_monitorable(change : bool):
    set_deferred("monitorable", change)


# func _process(_delta: float) -> void:
# 	print(collision_layer)