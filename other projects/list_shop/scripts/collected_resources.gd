@tool
class_name CollectedResources
extends Object

enum Types {
	RED,
	TUTORIAL_POINTS,
}

static var types:Array[int] = zero_array(Types.size())
static var type_textures:Array[Texture2D] = gen_color_bit_textures()

static func zero_array(len:int) -> Array[int]:
	var output:Array[int] = []
	for __ in len:
		output.append(0)
	return output

static func change_color(type:Types, val:int):
	types[type] += val

static func get_type(type:Types):
	return types[type]

static func get_color_of_type(type:Types):
	#return match color:
	#var out = match color:
	match type:
		Types.RED:
			return Color.RED

static func gen_color_bit_textures() -> Array[Texture2D]:
	var output:Array[Texture2D] = []
	for type in Types.values():
		output.append(
			ImageTexture.create_from_image(
				Image.create_from_data(1,1,false,Image.FORMAT_RGBAF,
				PackedColorArray([get_color_of_type(type)]).to_byte_array())
			)
		)
	return output

static func get_amount_bought(key:String) -> int:
	match key:
		_:
			return 0
