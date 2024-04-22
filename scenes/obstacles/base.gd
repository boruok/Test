@tool
extends StaticBody2D


signal stated(name)      # emitted when node state changed/door opened
signal interract(node)   # emitted when player interracted with node

@export var text := "hello world"   # message displayed with interract
@export var variant := 0:           # node sprite variant
	set(value):
		value = clamp(value, 0, $Sprite2D.hframes)
		variant = value
		$Sprite2D.frame = value


func collide(body: Node) -> void:
	interract.emit(self)
