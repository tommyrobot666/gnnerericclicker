class_name ShopItem
extends MarginContainer

@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/TextureRect
@onready var label: DynamicTextBox = $PanelContainer/HBoxContainer/CenterContainer/Label
@onready var cost_l: Label = $PanelContainer/HBoxContainer/Cost
@onready var buy_b: Button = $PanelContainer/HBoxContainer/Buy

var icon:Texture2D:
	set(x):
		assert(texture_rect != null)
		icon = x
		texture_rect.texture = x
var description:String:
	set(x):
		assert(label != null)
		description = x
		label.text = x
var get_amount_bought:IntSupplier
var cost:String:
	set(x):
		assert(cost_l != null)
		cost = x
		cost_l.text = cost+" "
var buy:Callable
var buy_requirements:BoolSupplier
var queue_free_after_buy:bool = false

@warning_ignore("shadowed_variable")
func set_data(description:String, cost:String, icon:Texture2D, buy:Callable, buy_requirements:BoolSupplier, get_amount_bought:IntSupplier = IntSupplier.new(), queue_free_after_buy:bool=false):
	self.description = description
	self.cost = cost
	self.icon = icon
	self.buy = buy
	self.buy_requirements = buy_requirements
	self.get_amount_bought = get_amount_bought
	self.queue_free_after_buy = queue_free_after_buy

func update_amount_bought():
	assert(get_amount_bought != null)
	var amount_bought:int = get_amount_bought.get_int_or_null()
	if amount_bought != null:
		self.label.text = "%s x %d" % [description, amount_bought]

func _on_buy_pressed():
	if !buy_requirements.get_bool():
		return
	var new_cost = buy.call()
	if new_cost is NewShopItemCost:
		cost = new_cost.cost
		buy_requirements = new_cost.buy_requirements
	if queue_free_after_buy:
		queue_free()
	else:
		if (get_amount_bought.f != null && get_amount_bought.f != Callable()):
			update_amount_bought()

func _ready() -> void:
	buy_b.pressed.connect(_on_buy_pressed)
	
	if (get_amount_bought != null && get_amount_bought.f != null && get_amount_bought.f != Callable()):
		update_amount_bought()
