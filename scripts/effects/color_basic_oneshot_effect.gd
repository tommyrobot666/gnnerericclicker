extends GPUParticles2D

@export var color:CollectedResources.Types:
	set(x):
		color = x
		modulate = CollectedResources.get_color_of_type(x).lerp(mix_color,mix_ratio)
@export var mix_color:Color
@export var mix_ratio:float
@export var force_timer:float = -1

func _ready() -> void:
	emitting = true
	one_shot = true
	finished.connect(_on_finished)

func _on_finished() -> void:
	if force_timer > 0:
		await get_tree().create_timer(force_timer).timeout
	queue_free()
