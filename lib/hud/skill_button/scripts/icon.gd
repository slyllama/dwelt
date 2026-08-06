extends Sprite2D
# Icon animations for skill transitions

@onready var original_y_scale := scale.y

func update_icon(icon: Texture2D = null) -> void:
	var _t := create_tween() # animate icon getting "squashed"
	_t.tween_property(self, "scale:y", 0.0, 0.08)
	await _t.finished
	
	# Update icon, but only if one has been specified; if not, clear it
	if icon: texture = icon
	else: texture = null
	
	var _u := create_tween() # animate icon getting "unsquashed"
	_u.tween_property(self, "scale:y", original_y_scale, 0.05)
