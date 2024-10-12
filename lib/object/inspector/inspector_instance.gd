class_name InspectorInstance extends Panel
@onready var model_root = get_node("Box3D/Viewport/InspectorWorld/ModelRoot")

func _process(_delta: float) -> void:
	model_root.global_rotation_degrees.y = -$OrbitHandler.target_rotation.y

# Disable orbiting if the cursor is out of the display box
func _on_mouse_entered() -> void: $OrbitHandler.disable_temporary = false
func _on_mouse_exited() -> void: $OrbitHandler.disable_temporary = true
