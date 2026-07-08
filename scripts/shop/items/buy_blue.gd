extends ShopItem2


func on_buy() -> NewShopItemCost:
	CollectedResources.buy_a_color_bit(CollectedResources.BoughtAmounts.BLUE)
	b_remove_cost()
	var new_color_bit = b_create_and_add_color_bit(CollectedResources.Types.BLUE)
	new_color_bit.bounce_spread = 11.67
	new_color_bit.gravity = 300
	return null
