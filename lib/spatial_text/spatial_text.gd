extends VisibleOnScreenNotifier3D

@export var text := "((Spatial Text))":
	set(_text): %Text.text = _text

func _process(_delta: float) -> void:
	if is_on_screen():
		var pos: Vector2 = Dwelt.camera.unproject_position(global_position)
		%Root2D.global_position = pos

# Handle visibility
func _on_screen_entered() -> void: %Root2D.visible = true
func _on_screen_exited() -> void: %Root2D.visible = false
