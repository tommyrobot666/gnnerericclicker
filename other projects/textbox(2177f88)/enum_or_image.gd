extends ImageTexture
class_name EnumOrImage

var is_none:bool = false

static func new_enum(val:int) -> EnumOrImage:
	return EnumOrImage.new(val)

static func new_image(image:Image) -> EnumOrImage:
	return EnumOrImage.new(-1,image)

static func new_texture(texture:Texture2D) -> EnumOrImage:
	return EnumOrImage.new(-1,texture.get_image())

static func none() -> EnumOrImage: #use none to clear a set image, use null to keep the current image
	return EnumOrImage.new(-1,null,true)

func _init(index:int=-1,image:Image=null,is_none:bool=false) -> void:
	if is_none:
		self.is_none = true
		return
	
	if index != -1:
		if GlobalChat.enum_to_image.size() < index:
			error_image()
		else:
			set_image(GlobalChat.enum_to_image[index].get_image())
	elif image != null:
		set_image(image)
	else:
		error_image()

func error_image():
	set_image(Image.new())
	printerr("ERR_INVALID_PARAMETER")
