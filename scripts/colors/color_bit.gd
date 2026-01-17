@tool
class_name ColorBit
extends RigidBody2D

const MESH_NODE_NAME := "MeshNode"
const TOUCH_AREA_NODE_NAME := "TouchArea"
const TOUCH_SCALE_MAX := 1.9
const TOUCH_SCALE_INCREASE := 1.32
const TOUCH_SCALE_DECREASE := 0.7

@export var color:CollectedResources.Types:
	set(x):
		color = x
		
		var mesh_node = get_node_or_null(MESH_NODE_NAME) as MeshInstance2D
		if mesh_node != null:
			mesh_node.texture = CollectedResources.type_textures[color]
@export var size:float = 10
@export var bounce_force:float = 300
@export var bounce_spread:float
@export var gravity:float = 250:
	set(x):
		gravity_scale = x
		gravity = x
@export var show_debug:bool

var touch_scale:float = 1
var touch_on_this_frame:bool = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("click"):
		return
	touch_on_this_frame = true
	click()

func click():
	apply_impulse(Vector2.UP.rotated(randf_range(-TAU*(1/bounce_spread), TAU*(1/bounce_spread))) * bounce_force)
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
	new_mesh_node.name = MESH_NODE_NAME
	add_child(new_mesh_node)
	
	var touch_area_shape:CollisionShape2D = CollisionShape2D.new()
	var touch_area_node:Area2D = Area2D.new()
	touch_area_shape.shape = CircleShape2D.new()
	touch_area_shape.shape.radius = size
	touch_area_node.name = TOUCH_AREA_NODE_NAME
	touch_area_node.add_child(touch_area_shape)
	add_child(touch_area_node)
	
	touch_area_node.input_event.connect(_on_input_event)
	
	lock_rotation = true
	input_pickable = false
	
	color = color
	gravity = gravity

func _process(delta: float) -> void:
	if show_debug:
		queue_redraw()
	
	if Engine.is_editor_hint():
		return
	
	var mesh_node:MeshInstance2D = get_node_or_null(MESH_NODE_NAME)
	if mesh_node:
		if linear_velocity.y < 0:
			mesh_node.scale = Vector2.ONE * lerpf(1,1.1,minf((touch_scale-1)/(TOUCH_SCALE_MAX-1),1))
		else :
			mesh_node.scale = Vector2.ONE
	
	
	if touch_on_this_frame:
		touch_on_this_frame = false
		touch_scale = minf(TOUCH_SCALE_MAX,touch_scale*TOUCH_SCALE_INCREASE)
	else:
		touch_scale = maxf(1,lerpf(touch_scale,touch_scale*TOUCH_SCALE_DECREASE,delta))
	var touch_area_node = get_node_or_null(TOUCH_AREA_NODE_NAME)
	if touch_area_node:
		touch_area_node.scale = Vector2.ONE * touch_scale

func _draw() -> void:
	if !show_debug:
		return
	
	draw_line(Vector2.ZERO, Vector2.UP.rotated(-TAU*(1/bounce_spread)) * 30, Color.AQUAMARINE)
	draw_line(Vector2.ZERO, Vector2.UP.rotated(TAU*(1/bounce_spread)) * 30, Color.AQUAMARINE)
	draw_line(Vector2.ZERO, linear_velocity*10, Color.AQUA)
	draw_circle(Vector2.ZERO, size*touch_scale, Color(Color.BURLYWOOD, 0.3))
	draw_string(SystemFont.new(),Vector2(100,0),str(touch_scale))
