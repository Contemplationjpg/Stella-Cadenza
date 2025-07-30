class_name StackingHitbox
extends Hitbox

signal gain_stack

func _ready() -> void:
    update_constant()

func constant_damage():
    while active and constant:
        # print("toggle")
        toggle_monitoriable_and_monitoring()
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
    # if active:
    #     update_constant()
    return monitorable

func change_active(change : bool):
    active = change
    set_deferred("monitorable", change)
    set_deferred("monitoring", change)
    if active:
        update_constant()

func update_constant():
    if active and constant:
        constant_damage()


func toggle_monitoriable_and_monitoring()-> bool:
    set_deferred("monitorable", not monitorable)
    set_deferred("monitoring", not monitoring)
    if not monitorable:
        already_hit_hitboxes = []
    return monitorable


func change_monitorable_and_monitoring(change : bool):
    set_deferred("monitorable", change)
    set_deferred("monitoring", change)
    if not monitorable:
        already_hit_hitboxes = []


# func _process(_delta: float) -> void:
# 	print(collision_layer)

func _on_area_entered(area:Area2D) -> void:
    print("found hurtbox")
    var hurtbox = area as Hurtbox
    if hurtbox:
        if hurtbox in already_hit_hitboxes:
            print("already have hitbox in list")
        else:
            print("adding " + hurtbox.name)
            already_hit_hitboxes.append(hurtbox)
            gain_stack.emit()
