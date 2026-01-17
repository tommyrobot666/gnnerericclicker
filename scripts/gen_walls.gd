@tool
extends Node2D

@export var top_wall:float = 100
@export var bottom_wall:float = 100
@export var left_wall:float = 100
@export var right_wall:float = 100
@export var regenerate:bool:
	set(x):
		for c in get_children():
			c.queue_free()
		generate()

func generate():
	for vec:Vector2 in [Vector2.UP*top_wall,Vector2.DOWN*bottom_wall,Vector2.LEFT*left_wall,Vector2.RIGHT*right_wall]:
		var new_body:StaticBody2D = StaticBody2D.new()
		var new_shape:CollisionShape2D = CollisionShape2D.new()
		var new_bound:WorldBoundaryShape2D = WorldBoundaryShape2D.new()
		
		new_body.position = vec
		new_shape.shape = new_bound
		new_bound.normal = -vec
		
		add_child(new_body)
		new_body.add_child(new_shape)

func _draw() -> void:
	if Engine.is_editor_hint():
		pass

func _ready() -> void:
	generate()
