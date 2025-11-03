#class_name ShopItemBuyEvents
extends Node

func buy_red():
	CollectedResources.change_color(CollectedResources.Colors.RED,-5)
	print("item bought")
	var new_color_bit = ColorBit.new()
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 200
	get_node("/root/Game/Node2D/Colors").add_child(new_color_bit)
	#%Colors.add_child(new_color_bit)
