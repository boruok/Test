extends "base.gd"

# popups
@export var _confirm_scene : PackedScene
@export var _inventory_scene : PackedScene
var _popup : Control
# levels
var _levels := {
	"house1": load("res://scenes/levels/house1.tscn"),
	"house2": load("res://scenes/levels/house2.tscn"),
	"street": load("res://scenes/levels/street.tscn"),
}
# world/player/points
@export var _player : Node
@export var _world : Node
var _outdoor_point := Vector2()
var _persistants := {}


func check_nodes() -> void:
	var tilemap := get_tree().get_first_node_in_group("tilemap")
	# signals
	for c in tilemap.get_children():
		if c.is_in_group("persist"):
			c.stated.connect(_on_Persistant_changed)
		if c.is_in_group("interract"):
			c.interract.connect(_on_Node_interract)
	# persistance
	if _persistants.has(tilemap.name):
		for child in tilemap.get_children():
			if child is Area2D:
				if child.name in _persistants[tilemap.name]:
					child.queue_free()
			elif child is StaticBody2D:
				if child.name in _persistants[tilemap.name]:
					child.locked = false
	else:
		_persistants[tilemap.name] = []


func change_level(scene_name: String) -> void:
	get_tree().get_first_node_in_group("tilemap").queue_free()
	_world.add_child(_levels[scene_name].instantiate())


func _ready() -> void:
	check_nodes()
	_player.connect("hp_changed", _on_Player_hp_changed)
	_player.connect("keys_changed", _on_Player_key_changed)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_menu"):
		if is_instance_valid(_popup):
			_popup.queue_free()
			get_tree().paused = false
		else:
			var popup := _inventory_scene.instantiate()
			popup.inventory = _player.inventory
			add_child(popup)
			_popup = popup
			get_tree().paused = true


func _on_Player_hp_changed(current: int, total: int) -> void:
	%HP.text = "HP %s/%s" % [current, total]


func _on_Player_key_changed(keys_left: int) -> void:
	%Keys.text = "Ключи: %s" % keys_left


func _on_Node_interract(node: Node) -> void:
	if node.text:
		$Dialogue.text = node.text
	else:
		if !node.locked:
			change_level(node.scene_name)
			await get_tree().process_frame
			check_nodes()

		if _player.keys and node.scene_name and !_popup:
			var popup_closed := func(message: String):
				_popup.queue_free()
				get_tree().paused = false

				if node.scene_name and message == "ok":
					# door
					node.stated.emit(node.name)
					var indoor := node.indoor as bool
					var point := node.position as Vector2
					# level
					change_level(node.scene_name)
					await get_tree().process_frame
					# player
					_player.keys -= 1
					if indoor:  # house -> street
						_player.position = _outdoor_point + Vector2.DOWN * 8
					else:       # street -> house
						_outdoor_point = point
						_player.position = get_tree().get_first_node_in_group("door").position + Vector2.UP * 8
					# finish
					check_nodes()

			_popup = _confirm_scene.instantiate()
			_popup.closed.connect(popup_closed)
			add_child(_popup)
			get_tree().paused = true


func _on_Persistant_changed(id: String) -> void:
	_persistants[get_tree().get_first_node_in_group("tilemap").name].append(id)
