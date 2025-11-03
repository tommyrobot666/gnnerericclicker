class_name ShopItemsEntry # extend to change amount_bought_supplier
extends Resource

@export var icon:Texture2D
@export_multiline var description:String
@export var one_time:bool
@export var cost:String
@export var on_buy_f_name:String
@export var amount_bought_key:String

func get_on_buy() -> Callable:
	return Callable(ShopItemBuyEvents,on_buy_f_name)

func get_amount_bought_supplier() -> IntSupplier:
	if one_time:
		return IntSupplier.new()
	else:
		return IntSupplier.new(
			func():
				return CollectedResources.get_amount_bought(amount_bought_key)
		)
