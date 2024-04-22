extends "base.gd"


func use(body: Node) -> void:
	body.hp_max -= 10
	depleted.emit()
	queue_free()
