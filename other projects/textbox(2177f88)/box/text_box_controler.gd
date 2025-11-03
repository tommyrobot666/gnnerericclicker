extends CanvasItem
class_name TextBoxControler

@export var text_box:DynamicTextBox
@export var name_box:DynamicTextBox
@export var face_box:Node
var get_top_of_box:Callable
@export var get_top_of_box_override:float
@export var speechs:Array[Speech] = []
var current_speech:Speech
var left_image:EnumOrImage = EnumOrImage.none()
var right_image:EnumOrImage = EnumOrImage.none()
var center_image:EnumOrImage = EnumOrImage.none()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAW:
			var offset:int
			if get_top_of_box != null:
				offset = -get_top_of_box.call()
			else:
				offset = -get_top_of_box_override
			
			if not left_image.is_none:
				draw_texture(left_image,Vector2(0,get_viewport_rect().size.y+(offset-left_image.get_height())))
			if not right_image.is_none:
				draw_texture(right_image,Vector2(get_viewport_rect().size.x-right_image.get_width(),get_viewport_rect().size.y+(offset-left_image.get_height())))
			if not center_image.is_none:
				draw_texture(center_image,Vector2((get_viewport_rect().size.x-right_image.get_width())/2,get_viewport_rect().size.y+(offset-left_image.get_height())))

func next_speech():
	if speechs.is_empty():
		current_speech = null
		return
	
	current_speech = speechs.pop_front()
	
	if current_speech.face_image != null:
		face_box.texture = current_speech.face_image
	if current_speech.left_image != null:
		left_image = current_speech.left_image
	if current_speech.right_image != null:
		right_image = current_speech.right_image
	if current_speech.center_image != null:
		center_image = current_speech.center_image
	
	name_box.speed = current_speech.speed
	text_box.speed = current_speech.speed
	
	if not current_speech.name.is_empty():
		name_box.text = current_speech.name
	text_box.text = current_speech.text
	
	queue_redraw()

func add_speech(speech:Speech):
	speechs.append(speech)
