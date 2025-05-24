class_name Hitbox
extends Area2D

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func take_damage(damage : int):
	print("took %d damage", damage)
	
