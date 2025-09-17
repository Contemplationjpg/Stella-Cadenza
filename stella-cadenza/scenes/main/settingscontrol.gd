extends Node 



@export var vol_slider : HSlider
@export var audio_stream : AudioStreamPlayer

var vol : float

func _ready():
	vol_slider.value = Main.volume
	_on_h_slider_value_changed(vol_slider.value)

func _on_h_slider_value_changed(value:float) -> void:
	vol = value
	if Main.volume != vol:
		Main.volume = vol
	audio_stream.volume_db = vol

func _on_resume_button_pressed() -> void:
	self.visible = false
	Main.paused = false
	
