#holds the camera and follows the player but drifts towards the mouse
extends Node2D

@export var camera : Camera2D
@export var player : Player
@export var min_distance : float = 50
@export var max_distance : float = 200
@export var camera_speed : float = 0.25

var anchor : Vector2
var mouse : Vector2
var target_position : Vector2


func _process(delta):
	anchor = player.global_position
	mouse = get_local_mouse_position()
	# print(anchor.x-mouse.x)
	# print(mouse.x)

	if abs(mouse.x) >= max_distance:
		target_position.x = anchor.x + (sign(mouse.x) * max_distance)
		# print("XMAX")
	elif abs(mouse.x) >= min_distance:
		target_position.x = anchor.x + mouse.x
	else:
		target_position.x = anchor.x
	
	
	if abs(mouse.y) >= max_distance:
		target_position.y = anchor.y + (sign(mouse.y)*max_distance)
		# print("YMAX")
	elif abs(mouse.y) >= min_distance:
		target_position.y = anchor.y + mouse.y
	else:
		target_position.y = anchor.y


	# if abs(mouse.y) >= max_distance/1.5:
	# 	target_position.y = anchor.y + (sign(mouse.y)*max_distance)/1.5
	# 	# print("YMAX")
	# elif abs(mouse.y) >= min_distance/1.5:
	# 	target_position.y = anchor.y + mouse.y/1.5
	# else:
	# 	target_position.y = anchor.y

	# print(target_position)


	var cam_move_speed = camera_speed * delta
	if abs(mouse.x) >= max_distance and abs(mouse.y) >= max_distance:
		cam_move_speed /= 1.4
	# print(target_position)
	# print(camera.global_position)
	# if camera.global_position == target_position:
	# 	return

	camera.global_position.x = lerp(anchor.x,target_position.x,cam_move_speed)
	camera.global_position.y = lerp(anchor.y,target_position.y,cam_move_speed)
	
