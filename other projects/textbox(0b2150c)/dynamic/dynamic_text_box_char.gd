extends RefCounted
class_name DynamicTextBoxChar

var char_int:int:
	get:
		return char_str.unicode_at(0)
var char_str:String = ""
var image:EnumOrImage = null
var offset:Vector2 = Vector2.ZERO
var size:int = 13
var color:Color
var font:Font
var width:float:
	get: 
		if image == null:
			return font.get_char_size(char_int,size).x# + offset.x
		else:
			return image.get_width()
var effects:Array[Callable] = []
var effect_infos:Array[Variant] = []
