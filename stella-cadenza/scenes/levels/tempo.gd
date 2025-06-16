class_name Tempo
extends Timer

@export var bpm : int = 100
@export var debug : TextureRect
var beat_duration : float
var beat_count : int = 0 #this is set up assuming all songs will be 4/4

func _ready():
	beat_duration = 60.0/bpm
	wait_time = beat_duration



func _on_timeout() -> void:
	beat_count+=1
	if debug:
		if beat_count%2 == 0:
			SignalBus.EvenBeat.emit()
		else:
			SignalBus.OddBeat.emit()
		if beat_count%4==0:
			debug.self_modulate.s = 1
			await get_tree().create_timer(beat_duration/2).timeout
			debug.self_modulate.s = 0
		else:
			debug.self_modulate.s = .25
			await get_tree().create_timer(beat_duration/2).timeout
			debug.self_modulate.s = 0
			
