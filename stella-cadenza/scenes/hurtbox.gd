class_name Hurtbox
extends Area2D

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
