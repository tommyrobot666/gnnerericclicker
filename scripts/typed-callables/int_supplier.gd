class_name IntSupplier
extends RefCounted

var f:Callable

func _init(f:Callable=Callable()) -> void:
	self.f = f

func get_int() -> int:
	assert(is_valid())
	return f.call()

func get_int_or_null() -> Variant:#int?: TODO: nullable types
	if is_valid():
		return f.call()
	else:
		return null

func is_valid() -> bool:
	return f != null && f != Callable() && f.is_valid()
