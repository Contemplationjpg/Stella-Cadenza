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
# @export var is_square : bool = true
# @export var is_circle : bool = false
@export var is_electric: bool = false


var already_hit_hurtboxes : Array = []

func _ready() -> void:
    update_constant()

func constant_damage():
    while active and constant:
        # print("toggle")
        toggle_monitoriable_and_monitoring()
        await get_tree().create_timer(constant_blink_time).timeout    

func clear_hit_hurtboxes():
    already_hit_hurtboxes = []

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
    # if active:
    #     update_constant()
    return monitorable

func change_active(change : bool):
    active = change
    change_monitorable_and_monitoring(change)
    if active:
        update_constant()
    # print("SECONDARY ", active)

func update_constant():
    if active and constant:
        constant_damage()

func toggle_monitoriable_and_monitoring()-> bool:
    set_deferred("monitorable", not monitorable)
    set_deferred("monitoring", not monitoring)
    if not monitorable:
        already_hit_hurtboxes = []
    return monitorable

func change_monitorable_and_monitoring(change : bool):
    set_deferred("monitorable", change)
    set_deferred("monitoring", change)
    if not monitorable:
        already_hit_hurtboxes = []

func _on_area_entered(area:Area2D) -> void:
    # print("SECONDARY found hurtbox")
    var hurtbox = area as Hurtbox
    if hurtbox:
        if hurtbox in already_hit_hurtboxes:
            return
            # print("SECONADRY already have hitbox in list")
        else:
            # print("SECONDARY adding " + hurtbox.name)
            already_hit_hurtboxes.append(hurtbox)

# func _process(_delta: float) -> void:
# 	print(collision_layer)

