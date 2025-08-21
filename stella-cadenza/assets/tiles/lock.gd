class_name Lock
extends StaticBody2D

@export var required_switches : Array[SwitchTile]
@export var is_or_gate : bool = false
@export var locked : bool = true

signal LockUpdate(state)

func _ready():
	if is_or_gate:
		for i in required_switches:
			print("LOCK connecting ", i.name)
			i.LeverHit.connect(check_requirements_or)
		check_requirements_or(false)
	else:
		for i in required_switches:
			print("LOCK connecting ", i.name)
			i.LeverHit.connect(check_requirements_and)
		check_requirements_and(false)

func check_requirements_and(_state:bool):
	# print("checking lock requirements AND")
	for i in required_switches:
		if not i.powered:
			# print("not all switches powered")
			enable_lock()
			return true
	# print("all switches powered")
	disable_lock()
	return false

func check_requirements_or(_state:bool):
	# print("checking lock requirements OR")
	for i in required_switches:
		if i.powered:
			# print("at least one switch powered")
			disable_lock()
			return false
	# print("no switches powered")
	enable_lock()
	return true


func enable_lock():
	get_node("CollisionShape2D").set_deferred("disabled",false)
	get_node("AnimatedSprite2D").set_deferred("visible",true)
	locked = true
	LockUpdate.emit(locked)

func disable_lock():
	get_node("CollisionShape2D").set_deferred("disabled",true)
	get_node("AnimatedSprite2D").set_deferred("visible",false)
	locked = false
	LockUpdate.emit(locked)
