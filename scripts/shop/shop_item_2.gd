class_name ShopItem2
extends MarginContainer

@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/TextureRect
@onready var label: RichTextLabel = $PanelContainer/HBoxContainer/CenterContainer/RichTextLabel
@onready var cost_l: Label = $PanelContainer/HBoxContainer/Cost
@onready var buy_b: Button = $PanelContainer/HBoxContainer/Buy

@export var icon:Texture2D:
	set(x):
		assert(texture_rect != null)
		icon = x
		texture_rect.texture = x
@export_multiline var description:String:
	set(x):
		assert(label != null)
		description = x
		label.text = x
@export var cost:String:
	set(x):
		assert(cost_l != null)
		cost = x
		cost_l.text = cost+" "
@export var one_time:bool
@export var show_amount_bought:bool
@export var amount_bought_key:String
@export var unlock_requirement:Dictionary[CollectedResources.Types,int]
@export var simple_buy_requirement:Dictionary[CollectedResources.Types,int]

## Override this
func on_buy() -> NewShopItemCost:
	return null 

## Overrideable
func get_amount_bought() -> int:
	return CollectedResources.get_amount_bought(amount_bought_key)

## Overrideable
func is_unlock_requirements_meet() -> bool:
	if unlock_requirement == null:
		return true
	
	for type in unlock_requirement.keys():
		var amount_needed:int = unlock_requirement.get(type,0)
		if amount_needed > CollectedResources.get_type(type):
			return false
	
	return true

## Overrideable
func is_buy_requirements_meet() -> bool:
	for type in simple_buy_requirement.keys():
		var amount_needed:int = simple_buy_requirement.get(type,0)
		if amount_needed > CollectedResources.get_type(type):
			return false
	return true


func update_amount_bought_text():
	if show_amount_bought:
		var amount_bought:int = get_amount_bought()
		if amount_bought != null:
			self.label.text = "%s x %d" % [description, amount_bought]

func _on_buy_pressed():
	if !is_buy_requirements_meet():
		return
	
	var new_cost = on_buy()
	
	if new_cost is NewShopItemCost:
		cost = new_cost.cost
	elif one_time:
		queue_free()
	
	update_amount_bought_text()

func _ready() -> void:
	buy_b.pressed.connect(_on_buy_pressed)
