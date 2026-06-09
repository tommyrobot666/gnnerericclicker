@tool
extends Control
class_name DynamicTextBox

signal parse_done

var chars:Array[DynamicTextBoxChar] = []
var parse_chars:Dictionary[String,Callable] = {} # changes this object and changes DynamicTextBoxParseSettings (adds text effects)

@export var start_parse_char = "["
@export var end_parse_char = "]"
@export_multiline var text:String = "":
	set(x):
		if is_inside_tree():
			parse_string(x)
			text = x
			queue_redraw()
		else:
			text = x
@export var speed = 0.1
@export var do_ticking_effects = true
@export var center_text = false
@export var set_min_size_to_text_size = false
@export var set_min_size_to_text_size_before_done = false
var last_delta:float
var skip_this_parse = false
var is_this_parse_done = true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAW:
			if center_text:
				var line_lengths:Array[int]
				var current_line_length:int
				for char in chars:
					if char.char_str == """
""" or current_line_length + char.width > size.x:
						line_lengths.append(current_line_length)
						current_line_length = 0
					else:
						current_line_length += char.width
				line_lengths.append(current_line_length)
				
				current_line_length = line_lengths.pop_front()
				var total_offset = Vector2(current_line_length,0)
				for char in chars:
					if do_ticking_effects:
						for i in char.effects.size():
							char.effects[i].call(char,i,last_delta)
					
					if char.image == null:
						draw_string(char.font,(Vector2(current_line_length/2,0)-(char.offset+total_offset+Vector2(0,char.font.get_ascent(char.size)-char.font.get_descent(char.size))))*Vector2(1,-1),char.char_str,HORIZONTAL_ALIGNMENT_LEFT,-1,char.size,char.color)
					else:
						draw_texture(char.image,(Vector2(current_line_length/2,0)-(char.offset+total_offset))*Vector2(1,-1),char.color) 
					
					if char.char_str == """
""" or (total_offset.x + char.width > size.x and not set_min_size_to_text_size):
						total_offset.y += char.font.get_ascent(char.size)+char.font.get_descent(char.size)
						if line_lengths.is_empty():
							current_line_length = 0
						else:
							current_line_length = line_lengths.pop_front()
						total_offset.x = current_line_length
					else:
						total_offset.x -= char.width
				
				
				
				
			else:
				var total_offset = Vector2.ZERO
				for char in chars:
					if do_ticking_effects:
						for i in char.effects.size():
							char.effects[i].call(char,i,last_delta)
					
					if char.image == null:
						draw_string(char.font,char.offset+total_offset+Vector2(0,char.font.get_ascent(char.size)-char.font.get_descent(char.size)),char.char_str,HORIZONTAL_ALIGNMENT_LEFT,-1,char.size,char.color)
					else:
						draw_texture(char.image,char.offset+total_offset,char.color) 
					
					if char.char_str == """
""" or total_offset.x + char.width > size.x:
						total_offset.y += char.font.get_ascent(char.size)+char.font.get_descent(char.size)
						total_offset.x = 0
					else:
						total_offset.x += char.width

func _ready() -> void:
	add_parse_chars("p",print_3)
	add_parse_chars("g",icon_image_effect)
	add_parse_chars("i",image_effect)
	add_parse_chars("c",color_effect)
	add_parse_chars("s",size_effect)
	add_parse_chars("f",font_effect)
	add_parse_chars("~",squash_and_stretch_effect)
	add_parse_chars("!",shake_effect)
	add_parse_chars("b",color_to_black_effect)
	add_parse_chars("w",color_to_white_effect)
	parse_string(text)
	if not do_ticking_effects:
		queue_redraw()
	if not is_inside_tree():
		OS.crash("idk")

func _process(delta: float) -> void:
	if do_ticking_effects:
		last_delta = delta
		queue_redraw()

func parse_string(str:String):
	if set_min_size_to_text_size_before_done:
		var new_size = Vector2.ZERO
		var current_line = 0
		var font = SystemFont.new()
		for cha in str:
			if cha == """
""":
				new_size.y += font.get_ascent(13)+font.get_descent(13)
				if current_line > new_size.x:
					new_size.x = current_line
				current_line = 0
			else:
				current_line += font.get_char_size(cha.unicode_at(0), 13).x
		if current_line > new_size.x:
			new_size.x = current_line
		size = new_size
	
	
	chars.clear()
	is_this_parse_done = false
	
	var i:int = 0
	var current_char:String = ""
	
	var parse_settings:DynamicTextBoxParseSettings = DynamicTextBoxParseSettings.new()
	var excape_char:bool = false
	var last_was_excape_char:bool = false
	var parse_effect:bool = false
	var current_effect_char:String = ""
	var effect_input:String = ""
	
	while i < str.length():
		current_char = str[i]
		
		if parse_effect:
			if current_effect_char == "":
				current_effect_char = current_char
				effect_input = ""
			elif current_char == end_parse_char:
				if parse_chars.has(current_effect_char):
					(parse_chars.get(current_effect_char) as Callable).call(effect_input,parse_settings,self)
				parse_effect = false
			else:
				effect_input += current_char
		else:
			if current_char == "\\":
				excape_char = not excape_char
				last_was_excape_char = true
			else:
				last_was_excape_char = false
			
			if not excape_char:
				if current_char == start_parse_char:
					parse_effect = true
					current_effect_char = ""
				else:
					var newchar = DynamicTextBoxChar.new()
					newchar.char_str = current_char
					newchar.color = parse_settings.color
					newchar.font = parse_settings.font
					newchar.size = parse_settings.size
					for key in parse_settings.effects.keys():
						newchar.effects.append(parse_settings.effects.get(key))
						newchar.effect_infos.append(parse_settings.effect_infos.get(key))
					chars.append(newchar)
					
					if not (Engine.is_editor_hint() or skip_this_parse or speed < 0):
						await get_tree().create_timer(speed).timeout
						if not do_ticking_effects:
							queue_redraw()
			elif not last_was_excape_char:
				excape_char = false
		
		i += 1
	
	is_this_parse_done = true
	skip_this_parse = false
	
	if set_min_size_to_text_size:
		var new_size = Vector2.ZERO
		var current_line = 0
		for char in chars:
			if char.char_str == """
""":
				new_size.y += char.font.get_ascent(char.size)+char.font.get_descent(char.size)
				if current_line > new_size.x:
					new_size.x = current_line
				current_line = 0
			else:
				current_line += char.width
		if current_line > new_size.x:
			new_size.x = current_line
		custom_minimum_size = new_size
		size = new_size
	
	parse_done.emit()

func add_parse_chars(char:String,effect:Callable):
	if effect.get_argument_count() != 3:
		return FAILED
	if char.length() != 1:
		return FAILED
	parse_chars[char] = effect



func print_3(arg1,arg2,arg3):
	print(arg1,arg2,arg3)

func color_to_white_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	parse_settings.color = Color.WHITE

func color_to_black_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	parse_settings.color = Color.BLACK

func color_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	parse_settings.color = Color.from_string(effect_input,parse_settings.color)

func size_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	parse_settings.size = int(effect_input)

func font_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	parse_settings.font = load("res://fonts/"+effect_input)

func squash_and_stretch_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	if not parse_settings.is_end_of_effect("squash_and_stretch"):
		parse_settings.add_effect("squash_and_stretch",squash_and_stretch_effect_char,str_to_var("Vector3("+effect_input+")"))

func squash_and_stretch_effect_char(char:DynamicTextBoxChar,i:int,delta:float):
	# get offset
	var offset_start:Vector3
	var offset:Array
	
	match typeof(char.effect_infos[i]):
		TYPE_VECTOR3:
			offset_start = char.effect_infos[i] as Vector3 #offset and speed
			offset = [Vector2(offset_start.x,offset_start.y),offset_start.z,true] #offset, speed, direction
		TYPE_ARRAY:
			offset = char.effect_infos[i] as Array
		_:
			return
	
	# do effect
	if offset[2]:
		char.offset = lerp(char.offset,offset[0],offset[1]*delta)
	else:
		char.offset = lerp(char.offset,-offset[0],offset[1]*delta)
	
	if (abs(char.offset) - abs(offset[0])).length_squared() < 0.1:
		offset[2] = !offset[2]
	
	char.effect_infos[i] = offset


func shake_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	if not parse_settings.is_end_of_effect("shake"):
		var input = str_to_var("Vector2("+effect_input+")")
		if input == null:
			input = str_to_var(effect_input)
		parse_settings.add_effect("shake",shake_effect_char,input)

func shake_effect_char(char:DynamicTextBoxChar,i:int,delta:float):
	# get offset
	var offset_start_speed:Vector2
	var offset_start:float
	var offset:Array
	
	match typeof(char.effect_infos[i]):
		TYPE_FLOAT,TYPE_INT:
			offset_start = char.effect_infos[i] as float #radius
			offset = [offset_start,0,Vector2(0,0)] #radius and speed and target
		TYPE_VECTOR2:
			offset_start_speed = char.effect_infos[i] as Vector2 #radius and speed
			offset = [offset_start_speed.x,offset_start_speed.y,Vector2(0,0)] #radius and speed and target
		TYPE_ARRAY:
			offset = char.effect_infos[i] as Array
		_:
			return
	
	# do effect
	if offset[1] != 0:
		char.offset = lerp(char.offset,offset[2],offset[1]*delta)
		
		if (abs(char.offset) - abs(offset[2])).length_squared() < 0.1:
			offset[2] = Vector2.from_angle(randf_range(0,TAU)) * randf() * offset[0]
	else:
		char.offset = Vector2.from_angle(randf_range(0,TAU)) * randf() * offset[0]
	
	
	char.effect_infos[i] = offset

func icon_image_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	var new_char = DynamicTextBoxChar.new()
	new_char.color = Color.WHITE
	new_char.image = EnumOrImage.new_texture(preload("res://icon.svg"))
	new_char.font = SystemFont.new()
	
	dynamic_text_box.chars.append(new_char)

func image_effect(effect_input:String,parse_settings:DynamicTextBoxParseSettings,dynamic_text_box:DynamicTextBox):
	var new_char = DynamicTextBoxChar.new()
	new_char.color = Color.WHITE
	new_char.image = EnumOrImage.new_texture(load("res://"+effect_input))
	new_char.font = SystemFont.new()
	
	dynamic_text_box.chars.append(new_char)
