@tool
class_name ShopItem2
extends MarginContainer

const COLOR_SPAWN_EFFECT = preload("uid://dpr8ysh6oxbcx")

@export var texture_rect: TextureRect# = $PanelContainer/HBoxContainer/TextureRect
@export var label: RichTextLabel# = $PanelContainer/HBoxContainer/CenterContainer/RichTextLabel
@export var cost_l: Label# = $PanelContainer/HBoxContainer/Cost
@export var buy_b: Button# = $PanelContainer/HBoxContainer/Buy

@onready var colors_spawn_location:Node = null if Engine.is_editor_hint() else Engine.get_main_loop().current_scene.get_node("/root/Game/Node2D/Colors")
@onready var resource_viewer_location:Container = null if Engine.is_editor_hint() else Engine.get_main_loop().current_scene.get_node("/root/Game/CanvasLayer/Control/MarginContainer/PanelContainer/MarginContainer/CollectedResourecesViewer")

@export var icon:Texture2D:
	set(x):
		#if texture_rect == null: return
		assert(texture_rect != null)
		icon = x
		texture_rect.texture = x
@export_multiline var description:String:
	set(x):
		#if label == null: return
		assert(label != null)
		description = x
		label.text = x
@export var cost:String:
	set(x):
		#if cost_l == null: return
		assert(cost_l != null)
		cost = x
		cost_l.text = cost+" "
@export var one_time:bool
@export var show_amount_bought:bool
@export var amount_bought_key:CollectedResources.BoughtAmounts
@export var unlock_requirement:Dictionary[CollectedResources.Types,int]
@export var simple_buy_requirement:Dictionary[CollectedResources.Types,int]
var new_buy_requirement:BoolSupplier

## Override this
func on_buy() -> NewShopItemCost:
	return null 

## Overrideable
func get_amount_bought() -> int:
	return CollectedResources.get_amount_bought_enum(amount_bought_key)

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
	if new_buy_requirement != null:
		return new_buy_requirement.get_bool()
	
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
		new_buy_requirement = new_cost.buy_requirements
	elif one_time:
		queue_free()
	
	update_amount_bought_text()

func _ready() -> void:
	if !Engine.is_editor_hint():
		buy_b.pressed.connect(_on_buy_pressed)




func b_enable_view(color:CollectedResources.Types):
	resource_viewer_location.enable_view(color)

func b_create_and_add_color_bit(
	color:CollectedResources.Types=CollectedResources.Types.RED,
	size:float = 10) -> ColorBit:
	var new_color_bit = ColorBit.new()
	new_color_bit.color = color
	new_color_bit.size = size
	colors_spawn_location.add_child(new_color_bit)
	var new_spawn_effect = COLOR_SPAWN_EFFECT.instantiate()
	new_spawn_effect.color = color
	colors_spawn_location.add_child(new_spawn_effect)
	return new_color_bit

func b_remove_cost():
	for color:CollectedResources.Types in simple_buy_requirement:
		if color != CollectedResources.Types.TUTORIAL_POINTS:
			CollectedResources.change_color(color,-simple_buy_requirement.get(color))
