extends Container

const ITEMS_SCENE = preload("../../scenes/shop/shop_item.tscn")
const DESCRIPTION_START = "[color=white][font_size=16]"

@export var items:ShopItems
@export var items_parent:Container

var h_sep_index = 0

func _process(delta: float) -> void:
	var i:int = 0
	while i < items.items.size():
		var item:ShopItemsEntry = items.items[i]
		if !item.unlock_requirements_meet():
			i += 1
			continue
		
		var item_node:ShopItem = ITEMS_SCENE.instantiate()
		item_node.data = item
		items_parent.add_child(item_node)
		item_node.set_data(
			DESCRIPTION_START+item.description,
			item.cost,
			item.icon,
			item.get_on_buy(),
			item.get_is_buy_requirements_meet(),
			item.get_amount_bought_supplier(),
			item.one_time
		)
		if item.one_time:
			items_parent.move_child(item_node,h_sep_index)
			h_sep_index += 1
		items.items.remove_at(i)
		i += 1
