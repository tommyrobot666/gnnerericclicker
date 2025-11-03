extends Container

const ITEMS_SCENE = preload("res://shop_item.tscn")

@export var items:Array[ShopItemsEntry]
@export var items_parent:Container

var h_sep_index = 1 # should be 0

func _ready() -> void:
	for item in items:
		var item_node:ShopItem = ITEMS_SCENE.instantiate()
		items_parent.add_child(item_node)
		item_node.set_data(
			item.description,
			item.cost,
			item.icon,
			item.get_on_buy(),
			item.get_amount_bought_supplier()
		)
		if item.one_time:
			items_parent.move_child(item_node,h_sep_index)
			h_sep_index += 1
