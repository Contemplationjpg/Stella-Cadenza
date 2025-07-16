extends CanvasLayer

@export var color : ColorRect

var changing : bool = false

func _ready():
	SignalBus.FlashFadeToBlack.connect(flash_fade_to_black)
	SignalBus.FadeToBlack.connect(block_screen)
	SignalBus.FadeFromBlack.connect(unblock_screen)
	var tween : Tween = create_tween()
	tween.tween_property(color, "modulate:a", 0.0, 0).from(1.0)
	await tween.finished
	# color.self_modulate.a = 0.0


func flash_fade_to_black():
	if not changing:
		block_screen()
		await SignalBus.FadeNotChanging
		unblock_screen()


func block_screen():
	if not changing:
		print("fading to black")
		changing = true
		var tween : Tween = create_tween()
		tween.tween_property(color, "modulate:a", 1.0, .5).from(0.0)
		await tween.finished
		changing = false
		SignalBus.FadeNotChanging.emit()
	else:
		print("cannot fade to black")
	

func unblock_screen():
	if not changing:
		print("fading from black")
		changing = true
		var tween : Tween = create_tween()
		tween.tween_property(color, "modulate:a", 0.0, 1.25).from(1.0)
		await tween.finished
		changing = false
		SignalBus.FadeNotChanging.emit()
	else:
		print("cannot fade from black")
	