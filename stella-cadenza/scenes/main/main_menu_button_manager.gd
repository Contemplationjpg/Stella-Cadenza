extends Control
@export var main_scene : PackedScene


var hovering_play : bool = false

# func _process(delta):


func _on_play_button_pressed() -> void:
	if main_scene and hovering_play:
		get_tree().change_scene_to_packed(main_scene)


func _on_play_button_mouse_exited() -> void:
	hovering_play = false
	print(hovering_play)

func _on_play_button_mouse_entered() -> void:
	hovering_play = true
	print(hovering_play)


func _on_no_quit_pressed() -> void:
	print("no quit")
