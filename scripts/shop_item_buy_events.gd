class_name ShopItemBuyEvents
extends Object

static var instance = ShopItemBuyEvents.new()

func test():
	print("working")

func buy_red():
	CollectedResources.change_color(CollectedResources.Types.RED,-5)
	print("item bought")
	var new_color_bit = create_and_add_color_bit()
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 200


func create_and_add_color_bit(
	color:CollectedResources.Types=CollectedResources.Types.RED,
	size:float = 10) -> ColorBit:
	var new_color_bit = ColorBit.new()
	new_color_bit.color = color
	new_color_bit.size = size
	Engine.get_main_loop().current_scene.get_node("/root/Game/Node2D/Colors").add_child(new_color_bit)
	return new_color_bit
