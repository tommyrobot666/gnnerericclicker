extends Resource
class_name Speech

signal do_next(chosen_option:int)

const DEFAULT_SPEED = 0.1

@export_multiline var text:String:
	set(new_value):
		if text != new_value:
			text = new_value
			emit_changed()
	get():
		return text

@export var name:String = "":
	set(new_value):
		if name != new_value:
			name = new_value
			emit_changed()
	get():
		return name

@export var face_image:EnumOrImage = null:
	set(new_value):
		if face_image != new_value:
			face_image = new_value
			emit_changed()
	get():
		return face_image

@export var left_image:EnumOrImage = null:
	set(new_value):
		if left_image != new_value:
			left_image = new_value
			emit_changed()
	get():
		return left_image

@export var right_image:EnumOrImage = null:
	set(new_value):
		if right_image != new_value:
			right_image = new_value
			emit_changed()
	get():
		return right_image

@export var center_image:EnumOrImage = null:
	set(new_value):
		if center_image != new_value:
			center_image = new_value
			emit_changed()
	get():
		return center_image

@export var speed:float = DEFAULT_SPEED:
	set(new_value):
		if speed != new_value:
			speed = new_value
			emit_changed()
	get():
		return speed

@warning_ignore("shadowed_variable")
func _init(text:String,do_next:Array[Callable]=[]) -> void:
	self.text = text
	for call in do_next:
		self.do_next.connect(call)

func with_name(name:String) -> Speech:
	self.name = name
	return self

func with_speed(speed:float) -> Speech:
	self.speed = speed
	return self

func with_face_image(image:EnumOrImage) -> Speech:
	self.face_image = image
	return self

func with_left_image(image:EnumOrImage) -> Speech:
	self.left_image = image
	return self

func with_right_image(image:EnumOrImage) -> Speech:
	self.right_image = image
	return self

func with_center_image(image:EnumOrImage) -> Speech:
	self.center_image = image
	return self
