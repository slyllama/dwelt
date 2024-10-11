extends VBoxContainer

@export var curio_id: String

func _on_mouse_entered() -> void:
	Curio.curio_hovered.emit(curio_id)

func _on_mouse_exited() -> void:
	Curio.curio_hovered.emit("none")
