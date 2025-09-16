class_name Tempo
extends Timer

var bpm : float = 100
@export var debug : TextureRect
@export var audio_stream : AudioStreamPlayer
var beat_duration : float
var beat_count : int = 0 #this is set up assuming all songs will be 4/4
var time_begin : float
var time_delay : float
var flashing : bool = false


func _ready():
	set_bpm(audio_stream.stream.bpm)
	# wait_time = beat_duration
	# start()
	audio_stream.play()
	SignalBus.PlaySong.connect(play_song)


func play_song(song_name : String):
	var path : String = "res://assets/music/" + song_name + ".mp3"
	print("trying to play song from ", path)
	if ResourceLoader.exists(path):
		audio_stream.stop()
		audio_stream.stream = load(path)
		set_bpm(audio_stream.stream.bpm)
		audio_stream.play()
	else:
		print("could not find song")

func _process(_delta: float) -> void:
	# print("flashing: ", flashing)
	var time : float = audio_stream.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	# print("Time is: ", time)
	var mod = find_mod(time, beat_duration)
	# print(mod)
	if not flashing:
		if mod < 0.02 and time > 0:
			if beat_count >= 4:
				beat_count = 0
			beat_count += 1
			# print("gaming ", time, " ", beat_count)
			flashing = true 
			if beat_count%2 == 0:
				debug.self_modulate.s = 1
				# print("even beat emitting")
				SignalBus.EvenBeat.emit()
			else:
				# print("odd beat emitting")
				SignalBus.OddBeat.emit()
			await get_tree().create_timer(beat_duration/2).timeout
			debug.self_modulate.s = 0
		flashing = false

func set_bpm(new_bpm : float):
	bpm = new_bpm
	print(bpm)
	beat_duration = 60.0/bpm 

func find_mod(a : float, b : float):
	if a < 0:
		a = -a
	if b < 0:
		b = -b
	var mod : float = a
	while mod >= b:
		mod = mod - b
	if a < 0:
		return -mod
	return mod

# func _on_timeout() -> void:
# 	beat_count+=1
# 	if debug:
# 		if beat_count%2 == 0:
# 			SignalBus.EvenBeat.emit()
# 		else:
# 			SignalBus.OddBeat.emit()
# 		if beat_count%4==0:
# 			debug.self_modulate.s = 1
# 			await get_tree().create_timer(beat_duration/2).timeout
# 			debug.self_modulate.s = 0
# 		else:
# 			debug.self_modulate.s = .25
# 			await get_tree().create_timer(beat_duration/2).timeout
# 			debug.self_modulate.s = 0
			


# func _on_audio_stream_player_2d_finished() -> void:
# 	print("AUDIO STOPPED!!!!!")
# 	wait_time = beat_duration
# 	beat_count=0
# 	start()
# 	audio_stream.play()
# 	# audio_stream.stream_paused = false
# 	# audio_stream.play()
