@tool
class_name HUDButton extends Button

@export var id := "id"

func _init() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	mouse_entered.connect(func():
		modulate = Color(1.1, 1.1, 1.1))
	mouse_exited.connect(func():
		modulate = Color(0.8, 0.8, 0.8))
