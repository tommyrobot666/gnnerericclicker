@tool
extends ShopItem2


func on_buy() -> NewShopItemCost:
	CollectedResources.buy_a_color_bit(CollectedResources.BoughtAmounts.RED)
	b_remove_cost()
	var new_color_bit = b_create_and_add_color_bit()
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 200
	return null
