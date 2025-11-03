extends RefCounted
class_name DynamicTextBoxParseSettings

var color = Color.BLACK
var font = SystemFont.new()
var size = 13
var effects:Dictionary[String,Callable] = {}
var effect_infos:Dictionary[String,Variant] = {}

func add_effect(name:String,effect:Callable,info:Variant):
	effects[name] = effect
	effect_infos[name] = info

func change_effect_info(name:String,info:Variant):
	effect_infos[name] = info

func is_end_of_effect(name:String) -> bool:
	if effects.has(name):
		effects.erase(name)
		effect_infos.erase(name)
		return true
	return false
