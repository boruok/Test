extends Area2D


signal stated(name)  # emitted when item picked
signal depleted      # emitted when item used/destoyed

@export var key := false
@export var depletable := true

@onready var icon := $Sprite2D.texture as Texture
@export var text := "item name"
@export var info := "item info"


func collide(body: Node) -> void:
	if key:
		body.keys += 1
		stated.emit(name)
		queue_free()
	else:
		if body.inventory.is_full():
			return
		body.inventory.add_item(self)
		stated.emit(name)
