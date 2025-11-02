@tool
class_name ColorBit
extends RigidBody2D

@export var color:CollectedResources.Colors
@export var size:float = 10
@export var bounce_spread:float
@export var show_debug:bool

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("click"):
		return
	
	apply_impulse(Vector2.UP.rotated(randf_range(-TAU*(1/bounce_spread), TAU*(1/bounce_spread))) * 100)
	CollectedResources.change_color(color,1)
	if show_debug:
		await get_tree().physics_frame
		print(linear_velocity)

func _ready() -> void:
	var new_shape:CollisionShape2D = CollisionShape2D.new()
	new_shape.shape = CircleShape2D.new()
	new_shape.shape.radius = size
	add_child(new_shape)
	
	var new_mesh_node:MeshInstance2D = MeshInstance2D.new()
	var new_mesh:SphereMesh = SphereMesh.new()
	new_mesh_node.mesh = new_mesh
	new_mesh.radial_segments = 1
	new_mesh.rings = 9
	new_mesh.radius = size
	new_mesh.height = 2*size
	add_child(new_mesh_node)
	
	input_event.connect(_on_input_event)
	
	lock_rotation = true

func _process(delta: float) -> void:
	if show_debug:
		queue_redraw()

func _draw() -> void:
	if !show_debug:
		return
	
	draw_line(Vector2.ZERO, Vector2.UP.rotated(-TAU*(1/bounce_spread)) * 30, Color.AQUAMARINE)
	draw_line(Vector2.ZERO, Vector2.UP.rotated(TAU*(1/bounce_spread)) * 30, Color.AQUAMARINE)
	draw_line(Vector2.ZERO, linear_velocity*10, Color.AQUA)
