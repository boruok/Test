class_name Inventory extends Node


@export var _capacity := 6
var _items : Array[Node]


func add_item(item: Node) -> void:
	_items.push_front(item)
	item.reparent(self)
	remove_child(item)
	item.depleted.connect(remove_item.bind(item))


func remove_item(item: Node) -> void:
	var idx := _items.find(item)
	if idx == -1:
		return  # not found
	_items.remove_at(idx)


func is_full() -> bool:
	return _items.size() == _capacity


func get_items() -> Array[Node]:
	return _items


func _exit_tree() -> void:
	# for possible leaked instances
	for item in _items:
		item.queue_free()
