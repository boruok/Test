extends "base.gd"


@export var indoor := false  # where door is inside house or outside
@export var locked := true:  # self explanatory
	set(value):
		if scene_name.is_empty() and !indoor:
			return
		locked = value
		$Sprite2D.frame = 0 if value else 1
		stated.emit(name)
@export var scene_name := ""


func collide(body: Node) -> void:
	interract.emit(self)
