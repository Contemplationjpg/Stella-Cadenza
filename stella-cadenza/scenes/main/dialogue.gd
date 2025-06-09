extends CanvasLayer
@export var name_text : RichTextLabel
@export var dialogue_text : RichTextLabel
@export var bg : TextureRect
@export var text_speed : float = .4
@export var scene_text_file : String
@export var sprite1 : TextureRect 
@export var sprite2 : TextureRect 

var scene_text = []
var char_name : String = ""
var current_line = 0
var visible_chars : float = 0
var in_progress : bool = false
var yapping : bool = false
var sprite_active : bool = false
var sprite1_chosen : bool = false
const SPRITEADDRESS : String = "res://assets/dialogue_sprites/"
const SCENEADDRESS : String = "res://assets/dialogue/"

func _ready():
	SignalBus.display_dialogue.connect(start_scene)
	visible = false
	bg.visible = true
	name_text.text = char_name
	# visible = false
	# scene_text = load_scene_text("test2")
	load_scene_text()
	in_progress = false
	yapping = false

func start_scene(file_name : String = scene_text_file):
	load_scene_text(file_name)
	in_progress = true
	visible = true
	

func load_scene_text(file_name : String = scene_text_file):
	var address = str(SCENEADDRESS,file_name,".json")
	if FileAccess.file_exists(address):
		# print("found file")
		var file = FileAccess.open(address, FileAccess.READ)

		var new_arr = []

		while file.get_position() < file.get_length():
			# print(file.get_position())
			var json_string = file.get_line()
			# var json = JSON.new()
			var parse_result = JSON.stringify(json_string)
			parse_result = parse_result.substr(1, parse_result.length()-2)
			# print(parse_result)
			new_arr.append(parse_result)

		current_line = 0
		visible_chars = 0
		scene_text = new_arr
		set_current_line()
		return new_arr

func clean_line_pause_game(line : String) -> String:
	if line.substr(0,2) == "$p":
		# print("should pause game here")
		SignalBus.ForcePauseGame.emit(true)
		current_line += 1
		return ""
	else:
		return line

func clean_line_change_actors(line : String) -> String:
	if line.substr(0,3) == "[1]":
		# print("sprite 1!")
		sprite2.self_modulate.v = 0.5
		sprite1.self_modulate.v = 1
		# sprite2.self_modulate.a = 0.5
		# sprite1.self_modulate.a = 1
		sprite1_chosen = true
		sprite_active = true
		return line.substr(3)
	elif line.substr(0,3) == "[2]":
		# print("sprite 2!")
		sprite1.self_modulate.v = 0.5
		sprite2.self_modulate.v = 1
		# sprite1.self_modulate.a = 0.5
		# sprite2.self_modulate.a = 1
		sprite1_chosen = false
		sprite_active = true
		return line.substr(3)
	elif line.substr(0,3) == "[0]":
		# print("no sprite!")
		sprite1.self_modulate.v = 0.5
		sprite2.self_modulate.v = 0.5
		# sprite1.self_modulate.a = 0.5
		# sprite2.self_modulate.a = 0.5
		sprite_active = false
		return line.substr(3)
	elif line.substr(0,3) == "[3]":
		# print("no sprite!")
		sprite1.self_modulate.v = 1
		sprite2.self_modulate.v = 1
		# sprite1.self_modulate.a = 1
		# sprite2.self_modulate.a = 1
		sprite_active = false
		return line.substr(3)
	else:
		return line

func clean_line_set_actors(line : String) -> String:
	if line.substr(0,2) == "$1":
		if line.substr(2) == "":
			# print("removing sprite 1")
			sprite1.texture = null
			current_line += 1
			return ""
		# print("changing sprite 1 to: ", line.substr(2))
		var new_address = str(SPRITEADDRESS,line.substr(2),".png") 
		if FileAccess.file_exists(new_address):
			var new_texture = load(new_address)
			sprite1.texture = new_texture
		current_line += 1
		return ""
	if line.substr(0,2) == "$2":
		if line.substr(2) == "":
			# print("removing sprite 2")
			sprite2.texture = null
			current_line += 1
			return ""
		# print("changing sprite 2 to: ", line.substr(2))
		var new_address = str(SPRITEADDRESS,line.substr(2),".png") 
		if FileAccess.file_exists(new_address):
			var new_texture = load(new_address)
			sprite2.texture = new_texture
		current_line += 1
		return ""
	else:
		return line

func clean_line_slashes(line : String) -> String:
	var new_line = line.replace('\\', '')
	return new_line

func clean_line_skip_blanks(line : String) -> String:
	var new_line = line
	while new_line == "" and current_line < scene_text.size():
		current_line += 1
		new_line = scene_text[current_line]
	return new_line

func clean_line_set_name(line : String) -> String:
	var new_line = line
	if line.substr(0,2) == "$n":
		char_name = line.substr(2)
		name_text.text = char_name
		current_line += 1
		new_line = scene_text[current_line]
	return new_line
		


func set_current_line() -> bool:
	# print("trying to set current line to ", current_line)
	if scene_text == []:
		return false
	if current_line < scene_text.size():

		# print("current line ", current_line, " is in scene_text size")
		var new_line : String = ""

		while new_line == "":
			if current_line < scene_text.size():
				new_line = clean_line_skip_blanks(scene_text[current_line])
				if new_line[0] == "$":
					new_line = clean_line_set_name(new_line)
					new_line = clean_line_pause_game(new_line)
					new_line = clean_line_set_actors(new_line)
				# print("new_line: ",new_line)
			else:
				return false
	
		new_line = clean_line_slashes(clean_line_change_actors(new_line))
		dialogue_text.text = new_line
		visible_chars = 0
		return true

	else:
		return false


func _process(_delta):
	if in_progress:
		if dialogue_text.visible_characters < scene_text[current_line].length():
			# print("yap")
			yapping = true
			visible_chars += text_speed / 60
			dialogue_text.visible_characters = int(visible_chars)
		else:
			visible_chars += scene_text[current_line].length()
			yapping = false
			# print("yap done")
		
		
func _physics_process(_delta: float) -> void:
	if in_progress:
		if Input.is_action_just_pressed("yes"):
			if yapping:
				dialogue_text.visible_characters = scene_text[current_line].length()
				# dialogue_text.visible_ratio = 1

			else:
				# dialogue_text.visible_ratio = 0
				dialogue_text.visible_characters = 0 
				current_line += 1
				in_progress = false
				yapping = false
				if set_current_line():
					Main.doing_dialogue = true
					in_progress = true
					yapping = true
				elif not in_progress:
					Main.doing_dialogue = false
					SignalBus.ForcePauseGame.emit(false)
					visible = false
