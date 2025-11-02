class_name CollectedResources
extends Node

enum Colors {
	RED,
}

static var colors:Array[int] = zero_array(Colors.size())

static func zero_array(len:int) -> Array[int]:
	var output:Array[int] = []
	for __ in len:
		output.append(0)
	return output

static func change_color(color:Colors, val:int):
	colors[color] += val

static func get_color(color:Colors):
	return colors[color]
