extends "res://lib/ui/ui_container/ui_container.gd"

signal button_pressed(id)

func _button_pressed(id: String) -> void:
	button_pressed.emit(id)
