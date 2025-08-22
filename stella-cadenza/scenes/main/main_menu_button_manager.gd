extends Control
@export var main_scene : PackedScene
@export var quit_message : Control

var showing_overwindow : bool = false


func _on_play_button_pressed() -> void:
	if main_scene:
		get_tree().change_scene_to_packed(main_scene)




func _on_quit_pressed() -> void:
	if quit_message and not showing_overwindow:
		print("quit")
		quit_message.visible = true
		showing_overwindow = true

func _on_no_quit_pressed() -> void:
	if quit_message:	
		print("no quit")
		quit_message.visible = false
		showing_overwindow = false


func _on_yes_quit_pressed() -> void:
	get_tree().quit()
