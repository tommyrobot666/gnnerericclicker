class_name BoolSupplier
extends RefCounted

var f:Callable
# used just in case f is an expencive opperation at the cost of memory
var cache:Variant 

func _init(f:Callable=Callable()) -> void:
	self.f = f

func get_bool() -> bool:
	cache = f.call()
	assert(is_valid())
	return cache

func get_bool_or_null() -> Variant:#bool?: TODO: update to 4.2 for nullable types
	cache = f.call()
	if is_valid():
		return cache
	else:
		return null

func is_valid() -> bool:
	return f != null && f != Callable() && cache is bool
