extends "base.gd"


func use(body: Node) -> void:
	body.hp += 1
	depleted.emit()
	queue_free()
