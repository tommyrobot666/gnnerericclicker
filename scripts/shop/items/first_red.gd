extends ShopItem2

@export var tutorial_ball:ColorBit

func on_buy() -> NewShopItemCost:
	CollectedResources.buy_a_color_bit(CollectedResources.BoughtAmounts.RED)
	b_remove_cost()
	CollectedResources.change_color(CollectedResources.Types.TUTORIAL_POINTS,1)
	var tutorial_ball_pos = tutorial_ball.global_position
	if tutorial_ball:
		tutorial_ball.queue_free()
	var new_color_bit
	for __ in range(2):
		new_color_bit = b_create_and_add_color_bit()
		new_color_bit.bounce_spread = 11.67
		new_color_bit.gravity = 200
	new_color_bit.global_position = tutorial_ball_pos
	return null
