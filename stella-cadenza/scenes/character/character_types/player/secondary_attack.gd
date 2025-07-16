class_name Player_Secondary_Attack
extends Attack

signal StartSecondaryAttack
signal StopSecondaryAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true
	# original_velocity = chara.max_velocity
	SignalBus.EvenBeat.connect(got_even_beat)
	SignalBus.OddBeat.connect(got_odd_beat)

func got_odd_beat():
	if attacks_on_odds:
		# print("odd")
		attack()
		return

func got_even_beat():
	if attacks_on_evens:
		# print("even")
		attack()
		return

func attack():
	if not in_forgiveness_timing:
		in_forgiveness_timing = true
		wait_for_attack()
	if should_be_attacking and in_forgiveness_timing:
		in_forgiveness_timing = false
		StartSecondaryAttack.emit()
		# can_attack = false
		sprite.visible = true
		hitbox.change_active(true)
		await get_tree().create_timer(active_time).timeout
		hitbox.change_active(false)
		sprite.visible = false
		StopSecondaryAttack.emit()

func wait_for_attack():
	await get_tree().create_timer(forgiveness).timeout
	if in_forgiveness_timing:
		in_forgiveness_timing = false	
