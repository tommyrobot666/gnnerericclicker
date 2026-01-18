extends GPUParticles2D

@export var color:CollectedResources.Types:
	set(x):
		color = x
		modulate = CollectedResources.get_color_of_type(x)

func _ready() -> void:
	emitting = true
	one_shot = true

func _on_finished() -> void:
	queue_free()
