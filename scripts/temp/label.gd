extends Label

func _process(delta: float) -> void:
	text = "red: %d" % CollectedResources.get_type(0)
