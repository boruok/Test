extends "popup.gd"


func _ready() -> void:
	%Cancel.button_down.connect(emit_signal.bind("closed", ""))
	%OK.button_down.connect(emit_signal.bind("closed", "ok"))
