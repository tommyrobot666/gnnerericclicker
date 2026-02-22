extends Container

@export var enabled_views:Array[CollectedResources.Types]
@export var text_size:float = 13

func _process(_delta: float) -> void:
	while enabled_views.size() > get_child_count():
		create_new_label(enabled_views.get(get_child_count()))
	
	for i in range(get_child_count()):
		var child = get_child(i)
		var color = enabled_views.get(i)
		child.text = CollectedResources.get_name_of_type(color)+": "+str(CollectedResources.get_type(color))

func create_new_label(type:CollectedResources.Types):
	var new_label = Label.new()
	var new_setteings = LabelSettings.new()
	new_setteings.font_color = CollectedResources.get_color_of_type(type)
	new_label.label_settings = new_setteings
	new_setteings.font_size = text_size
	add_child(new_label)

func enable_view(type:CollectedResources.Types):
	enabled_views.append(type)
