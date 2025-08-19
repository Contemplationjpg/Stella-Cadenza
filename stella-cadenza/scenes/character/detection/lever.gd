extends Node2D

@export var sprite : AnimatedSprite2D

@export var powered : bool
@export var switch_cooldown : float = 0.5

signal LeverHit(state)

func _ready():
	update_sprite()

var can_be_hit = true

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
		if hitbox.active:
			if can_be_hit:
				can_be_hit = false
				powered = not powered
				update_sprite()
				LeverHit.emit(powered)
				await get_tree().create_timer(switch_cooldown).timeout
				can_be_hit = true
			# else:
				# print("cant be hit")


