extends Node


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and !event.echo:
			if event.keycode == KEY_ESCAPE:
				get_tree().quit()
			elif event.keycode == KEY_F2:
				get_tree().reload_current_scene()
			elif event.keycode == KEY_F3:
				get_tree().debug_collisions_hint = !get_tree().debug_collisions_hint
				get_tree().reload_current_scene()
