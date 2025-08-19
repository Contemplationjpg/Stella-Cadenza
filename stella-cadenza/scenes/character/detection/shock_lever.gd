extends Node2D

@export var sprite : AnimatedSprite2D

@export var powered : bool
@export var hold_power : float = 1
@export var auto_unpower : float = 3

signal LeverHit(state)

var can_be_hit : bool = true
var powering_down : bool = true
var power_time_left : float = 0

func _ready():
	update_sprite()

func _process(delta: float) -> void:
	# print(power_time_left)
	if powered:
		if 	power_time_left > 0:
			power_time_left -= delta
		if power_time_left <= 0:
			powered = false
			update_sprite()
			LeverHit.emit(powered)


func update_sprite():
	if not sprite:
		return
	if powered:
		sprite.play("on")
	else:
		sprite.play("off")


func _on_hurtbox_area_entered(area:Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox:
		# print("SWITCH DETECTED HITBOX")
			if hitbox.active and hitbox.is_electric:
				if not powered:
					powered = false
					power_time_left = auto_unpower
					powered = true
					update_sprite()
					LeverHit.emit(powered)
				# else:
					# print("cant be hit")


