extends ShopItem2


func on_buy() -> NewShopItemCost:
	CollectedResources.buy_a_color_bit(CollectedResources.BoughtAmounts.RED_AUTOCLICKER_1)
	b_remove_cost()
	var new_color_bit = b_create_and_add_color_bit(CollectedResources.Types.RED,23)
	new_color_bit.bounce_spread = 6.915
	new_color_bit.gravity = 250
	new_color_bit.clicker = true
	new_color_bit.click_speed = .543434346767420
	new_color_bit.click_amount = 1
	new_color_bit.click_allowed_colors.append(CollectedResources.Types.RED)
	new_color_bit.modulate = Color(.85,.85,.85)
	return null
