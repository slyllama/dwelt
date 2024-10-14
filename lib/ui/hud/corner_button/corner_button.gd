extends TextureButton

func _ready() -> void:
	modulate.a = 0.6

func _on_mouse_entered() -> void:
	modulate.a = 1.0
	Global.hover_sound.emit()

func _on_mouse_exited() -> void:
	modulate.a = 0.6
