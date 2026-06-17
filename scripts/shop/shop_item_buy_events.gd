class_name ShopItemBuyEvents
extends Object

const COLOR_SPAWN_EFFECT = preload("res://scenes/effects/color_spawn_effect.tscn")

static var instance = ShopItemBuyEvents.new()

var boughtYellow:bool = false

# don't forget that you can change the price by returning a NewShopItemCost, it's very cool

func enable_view(color:CollectedResources.Types):
	Engine.get_main_loop().current_scene.get_node("/root/Game/CanvasLayer/Control/MarginContainer/PanelContainer/MarginContainer/CollectedResourecesViewer").enable_view(color)

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



func test():
	print("working")

func buy_first_red():
	CollectedResources.change_color(CollectedResources.Types.RED,-5)
	CollectedResources.change_color(CollectedResources.Types.TUTORIAL_POINTS,1)
	var tutorial_ball = Engine.get_main_loop().current_scene.get_node_or_null("/root/Game/Node2D/Colors/Red")
	if tutorial_ball:
		tutorial_ball.queue_free()
	for __ in range(2):
		var new_color_bit = create_and_add_color_bit()
		new_color_bit.bounce_spread = 11.67
		new_color_bit.gravity = 200

func buy_red():
	CollectedResources.change_color(CollectedResources.Types.RED,-5)
	var new_color_bit = create_and_add_color_bit()
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 200


func buy_first_blue():
	CollectedResources.change_color(CollectedResources.Types.RED,-20)
	CollectedResources.change_color(CollectedResources.Types.TUTORIAL_POINTS,1)
	var new_color_bit = create_and_add_color_bit(CollectedResources.Types.BLUE)
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 300
	enable_view(CollectedResources.Types.BLUE)

func buy_blue():
	CollectedResources.change_color(CollectedResources.Types.RED,-1)
	CollectedResources.change_color(CollectedResources.Types.BLUE,-5)
	var new_color_bit = create_and_add_color_bit(CollectedResources.Types.BLUE)
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 300


func buy_yellow():
	if (!instance.boughtYellow):
		enable_view(CollectedResources.Types.YELLOW)
		instance.boughtYellow = true
	CollectedResources.change_color(CollectedResources.Types.RED,-50)
	CollectedResources.change_color(CollectedResources.Types.BLUE,-100)
	var new_color_bit = create_and_add_color_bit(CollectedResources.Types.YELLOW,8)
	new_color_bit.bounce_spread = 4.485
	new_color_bit.gravity = 150

func buy_red_autoclicker():
	CollectedResources.change_color(CollectedResources.Types.RED,-200)
	CollectedResources.change_color(CollectedResources.Types.YELLOW,-10)
	var new_color_bit = create_and_add_color_bit(CollectedResources.Types.RED,23)
	new_color_bit.bounce_spread = 6.915
	new_color_bit.gravity = 250
	new_color_bit.clicker = true
	new_color_bit.click_speed = .543434346767420
	new_color_bit.click_amount = 1
	new_color_bit.click_allowed_colors.append(CollectedResources.Types.RED)
	new_color_bit.modulate = Color(.85,.85,.85)
