class_name Player_Primary_Attack
extends Attack


var player : Player

var attack_in_motion : bool = false


signal FullStopAttack

func _ready() -> void:
	sprite.visible = false
	can_attack = true
	# original_velocity = chara.max_velocity
	SignalBus.EvenBeat.connect(got_even_beat)
	SignalBus.OddBeat.connect(got_odd_beat)
	hitbox.gain_stack.connect(increase_stacks)
	player = chara as Player


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

func increase_stacks():
	# print("attempting to increase stacks")
	if player:
		if player.attack_stacks < player.stacks_needed:
			player.attack_stacks += 1


func attack():
	# print("SBA: ", should_be_attacking)
	if not in_forgiveness_timing:
		in_forgiveness_timing = true
		wait_for_attack()
	if should_be_attacking and in_forgiveness_timing:
		in_forgiveness_timing = false
		StartAttack.emit()
		if not attack_in_motion:
			attack_in_motion = true
		# can_attack = false
		sprite.visible = true
		hitbox.change_active(true)
		await get_tree().create_timer(active_time).timeout
		hitbox.change_active(false)
		sprite.visible = false
		StopAttack.emit()
	if not should_be_attacking:
		attack_in_motion = false
		FullStopAttack.emit()



func wait_for_attack():
	await get_tree().create_timer(forgiveness).timeout
	if in_forgiveness_timing:
		in_forgiveness_timing = false	
