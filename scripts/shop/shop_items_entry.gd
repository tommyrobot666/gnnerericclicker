class_name ShopItemsEntry # extend to change requirements and amount_bought_supplier
extends Resource

@export var icon:Texture2D
@export_multiline var description:String
@export var one_time:bool
@export var dont_show_amount_bought:bool
@export var cost:String
@export var on_buy_f_name:String
@export var amount_bought_key:String

@export var unlock_requirement:Dictionary[CollectedResources.Types,int]
var custom_unlock_requirement:BoolSupplier

@export var custom_buy_requirements:bool
@export var simple_buy_requirement:Dictionary[CollectedResources.Types,int]
@export_group("custom_buy_requirements","custom_buy_requirements")
@export var custom_buy_requirements_path:NodePath
@export var custom_buy_requirements_name:String


func get_on_buy() -> Callable:
	return Callable(ShopItemBuyEvents.instance,on_buy_f_name)

func get_amount_bought_supplier() -> IntSupplier:
	if one_time || dont_show_amount_bought:
		return IntSupplier.new()
	else:
		return IntSupplier.new(
			func():
				return CollectedResources.get_amount_bought(amount_bought_key)
		)

func unlock_requirements_meet() -> bool:
	if custom_unlock_requirement != null:
		return custom_unlock_requirement.get_bool()
	
	if unlock_requirement == null:
		return true
	
	for type in unlock_requirement.keys():
		var amount_needed:int = unlock_requirement.get(type,0)
		if amount_needed > CollectedResources.get_type(type):
			return false
	
	return true

func get_is_buy_requirements_meet() -> BoolSupplier:
	if simple_buy_requirement == null:
		var node = Engine.get_main_loop().current_scene.get_node(custom_buy_requirements_path)
		return BoolSupplier.new(Callable(node,custom_buy_requirements_name))
	
	return new_is_buy_requirements_meet(simple_buy_requirement)

static func new_is_buy_requirements_meet(simple_buy_requirement:Dictionary[CollectedResources.Types,int]) -> BoolSupplier:
	return BoolSupplier.new(func():
		for type in simple_buy_requirement.keys():
			var amount_needed:int = simple_buy_requirement.get(type,0)
			if amount_needed > CollectedResources.get_type(type):
				return false
		return true
	)
