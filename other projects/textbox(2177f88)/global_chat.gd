extends Node

var enum_to_image:Array[Texture2D] = [
	preload("res://icon.svg")
]

enum images {
	godot
}

var global_speech_stack:Array[Speech] = []
