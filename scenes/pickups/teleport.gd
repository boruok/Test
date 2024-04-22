extends "base.gd"


func use(body: Node2D) -> void:
	body.position = Vector2(randf() * 320, randf() * 180)
	depleted.emit()
	queue_free()
