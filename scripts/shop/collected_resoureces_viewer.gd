extends Container

const last_values_update_speed:float = 0.01

@export var enabled_views:Array[CollectedResources.Types]
@export var text_size:float = 13
@export var debug_starting_values:Array[int]
var last_values:Array[int]
@export var time_until_update_last_values:float = 1#1000 ms
var time_since_update_last_values:float = time_until_update_last_values
@export var time_to_spend_updating_last_values:float = .5#500 ms
var time_spent_update_last_values:float = 0

func _ready() -> void:
	for i in range(debug_starting_values.size()):
		CollectedResources.change_color(i,debug_starting_values.get(i))

func _process(delta: float) -> void:
	while enabled_views.size() > get_child_count():
		create_new_label(enabled_views.get(get_child_count()))
	
	for i in range(get_child_count()):
		var child = get_child(i)
		var color = enabled_views.get(i)
		var last_value = last_values.get(i)
		var value = CollectedResources.get_type(color)
		if value != last_value:
			child.text = CollectedResources.get_name_of_type(color)+": "+str(last_value)+"  +"+str(value-last_value)
		else:
			child.text = CollectedResources.get_name_of_type(color)+": "+str(last_value)
	
	
	if time_since_update_last_values >= time_until_update_last_values:
		time_spent_update_last_values += delta
		
		
		var all_same:bool = true
		for i in range(last_values.size()):
			var color = enabled_views.get(i)
			var last_value = last_values.get(i)
			var value = CollectedResources.get_type(color)
			last_values.set(i,lerpf(last_value,value,min(last_values_update_speed*delta,1)))
			
			if last_value != value:
				all_same = false
		
		if all_same or time_spent_update_last_values>time_to_spend_updating_last_values:
			time_since_update_last_values = 0
			time_spent_update_last_values = 0
			for i in range(last_values.size()):
				var color = enabled_views.get(i)
				var value = CollectedResources.get_type(color)
				last_values.set(i,value)
			
	
	
	time_since_update_last_values += delta

func create_new_label(type:CollectedResources.Types):
	var new_label = Label.new()
	var new_setteings = LabelSettings.new()
	new_setteings.font_color = CollectedResources.get_color_of_type(type)
	new_label.label_settings = new_setteings
	new_setteings.font_size = text_size
	last_values.append(0)
	add_child(new_label)

func enable_view(type:CollectedResources.Types):
	enabled_views.append(type)
