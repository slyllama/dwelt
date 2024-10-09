extends TextureButton
# CloseButton

func _on_mouse_entered() -> void:
	Global.hover_sound.emit()

func _on_button_down() -> void:
	Global.click_sound.emit()
