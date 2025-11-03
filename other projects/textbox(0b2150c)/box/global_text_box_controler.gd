extends TextBoxControler

@export var next_action:String
@export var skip_action:String
@export var skip_all_action:String
var skipping = false

func _init() -> void:
	speechs = GlobalChat.global_speech_stack

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(skip_action) or Input.is_action_pressed(skip_all_action):
		text_box.skip_this_parse = true
		skipping = true
	if (Input.is_action_just_pressed(next_action) or skipping) and text_box.is_this_parse_done:
		next_speech()
	if current_speech == null and not speechs.is_empty():
		next_speech()
