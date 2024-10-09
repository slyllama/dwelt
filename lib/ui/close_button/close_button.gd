extends TextureButton
# CloseButton

func _on_mouse_entered() -> void:
	Global.hover_sound.emit()

func _on_pressed() -> void:
	Global.click_sound.emit()
