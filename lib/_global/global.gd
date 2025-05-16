extends Node
# Global
# Hands highest-level things, like retina window content scaling

func _ready() -> void:
	if get_window().size.x > 2000:
		get_window().content_scale_factor = 2.0
