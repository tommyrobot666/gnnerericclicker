class_name StateMachine
extends Node
## Hierarchical State machine for the player.
##
## Initializes states and delegates engine callbacks ([method Node._physics_process],
## [method Node._unhandled_input]) to the state.
## https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

"""
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
	1. _init()
	2. _enter_tree()
	3. _ready()
	4. _process()
	5. _physics_process()
	6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses
"""

signal state_changed(previous, new)

@export var initial_state: Node
var is_active = true:
	set = set_is_active

@onready var _state = initial_state:
	set = set_state
@onready var _state_name = _state.name


func _init():
	add_to_group("state_machine")


func _enter_tree():
	print("this happens before the ready method!")


func _ready():
	state_changed.connect(_on_state_changed)
	_state.enter()


func _unhandled_input(event):
	_state.unhandled_input(event)


func _physics_process(delta):
	_state.physics_process(delta)


func transition_to(target_state_path, msg={}):
	if not has_node(target_state_path):
		return

	var target_state = get_node(target_state_path)
	assert(target_state.is_composite == false)

	_state.exit()
	self._state = target_state
	_state.enter(msg)
	#Events.player_state_changed.emit(_state.name)


func set_is_active(value):
	is_active = value
	set_physics_process(value)
	set_process_unhandled_input(value)
	set_block_signals(not value)


func set_state(value):
	_state = value
	_state_name = _state.name


func _on_state_changed(previous, new):
	print("state changed")
	state_changed.emit()


class State:
	var foo = 0

	func _init():
		print("Hello!")
