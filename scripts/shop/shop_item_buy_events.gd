class_name ShopItemBuyEvents
extends Node

static func buy_red():
	CollectedResources.change_color(CollectedResources.Colors.RED,-5)
	print("item bought")
