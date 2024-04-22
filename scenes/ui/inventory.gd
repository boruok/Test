extends "popup.gd"


var inventory : Inventory:
	set(value):
		inventory = value
		var items := inventory.get_items()
		for i in items.size():
			%ItemList.get_child(i).icon = items[i].icon
			%ItemList.get_child(i).set_meta("item", items[i])
var _item : Node2D
var _button : Button


func _ready() -> void:
	for button in %ItemList.get_children():
		button.button_down.connect(_on_ItemButton_picked.bind(button))
	%Use.button_down.connect(_on_Use_button_down)
	%Drop.button_down.connect(_on_Drop_button_down)


func _change_item_info(item_name: String, item_info: String):
	%Name.text = item_name
	%Info.text = item_info


func _toggle_item_button(value: bool) -> void:
	%Use.disabled = value
	%Drop.disabled = value


func _on_ItemButton_picked(button: Button) -> void:

	if button.has_meta("item"):
		_button = button
		_item = button.get_meta("item")
		_change_item_info(_item.text, _item.info)
		_toggle_item_button(!_item.depletable)
	else:
		_change_item_info("Название", "Описание")
		_toggle_item_button(true)


func _on_Use_button_down() -> void:
	_item.use(get_tree().get_first_node_in_group("player"))
	_button.remove_meta("item")
	_button.icon = null
	_change_item_info("Название", "Описание")
	_toggle_item_button(true)


func _on_Drop_button_down() -> void:
	# item
	var tilemap := get_tree().get_first_node_in_group("tilemap")
	inventory.remove_item(_item)
	tilemap.add_child(_item)
	_item.position = get_tree().get_first_node_in_group("player").position
	# button
	_button.remove_meta("item")
	_button.icon = null
	# other
	_change_item_info("Название", "Описание")
	_toggle_item_button(true)
	# TODO world must remember where a new node is dropped
