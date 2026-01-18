class_name ShopItemBuyEvents
extends Object

const COLOR_SPAWN_EFFECT = preload("res://scenes/effects/color_spawn_effect.tscn")

static var instance = ShopItemBuyEvents.new()

func test():
	print("working")

func buy_red():
	CollectedResources.change_color(CollectedResources.Types.RED,-5)
	print("item bought")
	var new_color_bit = create_and_add_color_bit()
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 200


func buy_first_red():
	CollectedResources.change_color(CollectedResources.Types.RED,-5)
	CollectedResources.change_color(CollectedResources.Types.TUTORIAL_POINTS,1)
	print("item not bought")
	var tutorial_ball = Engine.get_main_loop().current_scene.get_node_or_null("/root/Game/Node2D/Colors/Red")
	if tutorial_ball:
		tutorial_ball.queue_free()
	for __ in range(2):
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
	var new_spawn_effect = COLOR_SPAWN_EFFECT.instantiate()
	new_spawn_effect.color = color
	Engine.get_main_loop().current_scene.get_node("/root/Game/Node2D/Colors").add_child(new_spawn_effect)
	return new_color_bit
