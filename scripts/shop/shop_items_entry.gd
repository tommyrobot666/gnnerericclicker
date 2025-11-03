class_name ShopItemsEntry # extend to change requirements and amount_bought_supplier
extends Resource

@export var icon:Texture2D
@export_multiline var description:String
@export var one_time:bool
@export var dont_show_amount_bought:bool
@export var cost:String
@export var on_buy_f_name:String
@export var amount_bought_key:String
@export var simple_requirement:Dictionary[CollectedResources.Colors,int]

func get_on_buy() -> Callable:
	return Callable(ShopItemBuyEvents,on_buy_f_name)

func get_amount_bought_supplier() -> IntSupplier:
	if one_time || dont_show_amount_bought:
		return IntSupplier.new()
	else:
		return IntSupplier.new(
			func():
				return CollectedResources.get_amount_bought(amount_bought_key)
		)

func requirements_meet() -> bool:
	if simple_requirement == null:
		return true
	
	for color in simple_requirement.keys():
		var amount_needed:int = simple_requirement.get(color,0)
		if amount_needed > CollectedResources.get_color(color):
			return false
	
	return true
