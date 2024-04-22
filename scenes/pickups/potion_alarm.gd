extends "base.gd"


func use(body: Node) -> void:
	# body tree used because node/item not in the tree
	for door in body.get_tree().get_nodes_in_group("door"):
		door.locked = true
	depleted.emit()
	queue_free()
