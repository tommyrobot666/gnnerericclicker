extends ShopItem2

var boughtYellow = false

func on_buy() -> NewShopItemCost:
	CollectedResources.buy_a_color_bit(CollectedResources.BoughtAmounts.YELLOW)
	if (!boughtYellow):
		b_enable_view(CollectedResources.Types.YELLOW)
		boughtYellow = true
	var yellowcost = CollectedResources.get_amount_bought("YELLOW") *5
	CollectedResources.change_color(CollectedResources.Types.RED,-50)
	CollectedResources.change_color(CollectedResources.Types.BLUE,-100)
	CollectedResources.change_color(CollectedResources.Types.YELLOW,-yellowcost +5)
	var new_color_bit = b_create_and_add_color_bit(CollectedResources.Types.YELLOW,8)
	new_color_bit.bounce_spread = 4.485
	new_color_bit.gravity = 150
	
	return NewShopItemCost.new("50R 100B "+str(yellowcost)+"Y",
	ShopItemsEntry.new_is_buy_requirements_meet({
		CollectedResources.Types.RED:50,
		CollectedResources.Types.BLUE:100,
		CollectedResources.Types.YELLOW:yellowcost,
	}))
