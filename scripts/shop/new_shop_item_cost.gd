class_name NewShopItemCost
extends RefCounted

var cost:String
var buy_requirements:BoolSupplier

func _init(cost,buy_requirements) -> void:
	self.cost=cost
	self.buy_requirements=buy_requirements
