class_name Player_Primary_Attack
extends Attack

signal StartPrimaryAttack
signal StopPrimaryAttack

var player : Player


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
	print("attempting to increase stacks")
	if player:
		if player.attack_stacks < player.stacks_needed:
			player.attack_stacks += 1


func attack():
	if not in_forgiveness_timing:
		in_forgiveness_timing = true
		wait_for_attack()
	if should_be_attacking and in_forgiveness_timing:
		in_forgiveness_timing = false
		StartPrimaryAttack.emit()
		# can_attack = false
		sprite.visible = true
		hitbox.change_active(true)
		await get_tree().create_timer(active_time).timeout
		hitbox.change_active(false)
		sprite.visible = false
		StopPrimaryAttack.emit()

func wait_for_attack():
	await get_tree().create_timer(forgiveness).timeout
	if in_forgiveness_timing:
		in_forgiveness_timing = false	
