extends "base.gd"


func use(body: Node) -> void:
	body.hp -= 9
	body.hp_max += 1
