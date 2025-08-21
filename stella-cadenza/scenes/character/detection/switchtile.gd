class_name SwitchTile

extends Node

@export var powered : bool
@export var hittable : bool = true

@export var lock : Lock = null

signal LeverHit(state)

func _ready():
	update_sprite()
	if lock:
		print("connecting lock")
		lock.LockUpdate.connect(update_hittable)	
		update_hittable(lock.locked)
	else:
		print("NO LOCK")

func update_sprite():
	pass

func update_hittable(locked: bool):
	hittable = not locked
