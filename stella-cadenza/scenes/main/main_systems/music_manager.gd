extends Node
@export var audio_player : AudioStreamPlayer2D

func _ready():
	SignalBus.PlaySong.connect(play_song)


func play_song(song_name : String):
	var path : String = "res://assets/music/" + song_name + ".mp3"
	audio_player.stream = load(path)
	audio_player.play()