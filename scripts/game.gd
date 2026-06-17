extends Node

func _process(_delta: float) -> void:
	# advance tutorial after 100 red has been collected
	if (CollectedResources.get_type(CollectedResources.Types.TUTORIAL_POINTS) == 2 && CollectedResources.get_type(CollectedResources.Types.RED) > 99):
		CollectedResources.change_color(CollectedResources.Types.TUTORIAL_POINTS,1)
