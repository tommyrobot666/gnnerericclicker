class_name ShopItemsGroup
extends VBoxContainer

@export var unlock_requirement:Dictionary[CollectedResources.Types,int]

var unlocked
var all_childred_unlocked

func _ready() -> void:
	for child in get_children():
			var shop_item = child as ShopItem2
			if shop_item != null:
				shop_item.hide()
	hide()

func _process(_delta: float) -> void:
	if all_childred_unlocked:
		return
	
	if unlocked:
		var total_unlocked_items = 0
		for child in get_children():
			var shop_item = child as ShopItem2
			if shop_item == null:
				total_unlocked_items += 1
				continue
			if shop_item.visible:
				total_unlocked_items += 1
				continue
			
			if shop_item.is_unlock_requirements_meet():
				shop_item.show()
				total_unlocked_items += 1
		if total_unlocked_items == get_child_count():
			all_childred_unlocked = true
	else:
		if is_unlock_requirements_meet():
			unlocked = true
			show()

## Overrideable
func is_unlock_requirements_meet() -> bool:
	if unlock_requirement == null:
		return true
	
	for type in unlock_requirement.keys():
		var amount_needed:int = unlock_requirement.get(type,0)
		if amount_needed > CollectedResources.get_type(type):
			return false
	
	return true
