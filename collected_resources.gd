@tool
class_name CollectedResources
extends Node

enum Colors {
	RED,
}

static var colors:Array[int] = zero_array(Colors.size())
static var color_textures:Array[Texture2D] = gen_color_bit_textures()

static func zero_array(len:int) -> Array[int]:
	var output:Array[int] = []
	for __ in len:
		output.append(0)
	return output

static func change_color(color:Colors, val:int):
	colors[color] += val

static func get_color(color:Colors):
	return colors[color]

static func get_color_of_color(color:Colors):
	#return match color:
	#var out = match color:
	match color:
		Colors.RED:
			return Color.RED

static func gen_color_bit_textures() -> Array[Texture2D]:
	var output:Array[Texture2D] = []
	for color in Colors.values():
		output.append(
			ImageTexture.create_from_image(
				Image.create_from_data(1,1,false,Image.FORMAT_RGBAF,
				PackedColorArray([get_color_of_color(color)]).to_byte_array())
			)
		)
	return output
