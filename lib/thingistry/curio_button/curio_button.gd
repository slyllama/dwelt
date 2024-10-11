class_name CurioButton extends VBoxContainer

@export var curio_id: String

# Send the global position of this button up the chain when hovered
# This allows Thingistry to move its cursor to it
signal mouse_entered_button(global_position)

func get_center() -> Vector2:
	return($Button.global_position + $Button.size / 2) # center global position

func _ready() -> void:
	$Progress.value = Curio.get_progress(curio_id) * 100

func _on_mouse_entered() -> void:
	mouse_entered_button.emit(get_center())
	Curio.curio_selected.emit(curio_id)
