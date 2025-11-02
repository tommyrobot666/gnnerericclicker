extends MarginContainer

@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/TextureRect
@onready var label: Label = $PanelContainer/HBoxContainer/CenterContainer/Label
@onready var cost_l: Label = $PanelContainer/HBoxContainer/Cost
@onready var buy_b: Button = $PanelContainer/HBoxContainer/Buy

var icon:Texture2D:
	set(x):
		icon = x
		texture_rect.texture = x
var description:String:
	set(x):
		description = x
		label.text = x
var get_amount_bought:Callable
var cost:String:
	set(x):
		cost = x
		cost_l.text = cost+" "
var buy:Callable:
	set(x):
		buy = x
		buy_b.pressed.connect(buy)
var _queue_free_after_buy:bool = false

static func null_amount_bought():
	return null

@warning_ignore("shadowed_variable")
func set_data(description:String, cost:String, icon:Texture2D, buy:Callable, get_amount_bought:Callable = null_amount_bought):
	self.description = description
	self.cost = cost
	self.icon = icon
	self.buy = buy
	self.get_amount_bought = get_amount_bought
	if get_amount_bought == null_amount_bought:
		_queue_free_after_buy = true

func update_amount_bought():
	assert(!(get_amount_bought == null || get_amount_bought == Callable()))
	
	var amount_bought:int = get_amount_bought.call()
	if amount_bought != null:
		self.label.text = "%s x %d" % [description, amount_bought]

func _on_buy_pressed():
	if _queue_free_after_buy:
		queue_free()
