extends PanelContainer
# Tooltip to show effect details

func get_visibility() -> bool:
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		return(false)
	if !get_window().has_focus():
		return(false)
	if !get_window().gui_get_hovered_control():
		return(false)
	elif !get_window().gui_get_hovered_control().get_parent() is EffectCard:
		return(false)
	return(true)

func update_position_offsets() -> void:
	# Adjust the position of the tooltip to prevent it from falling off the screen
	var position_offset := Vector2.ZERO
	var window_scaled_size: Vector2 = get_viewport().size / get_viewport().content_scale_factor
	if get_window().get_mouse_position().y + size.y + 30.0 > window_scaled_size.y:
		position_offset.y = -size.y
	if get_window().get_mouse_position().x + size.x + 30.0 > window_scaled_size.x:
		position_offset.x = -size.x
	global_position = get_window().get_mouse_position() + position_offset + Vector2(15.0, 15.0)

func _process(_delta: float) -> void:
	# Only show the tooltip if the cursor is in use and a control with an
	# EffectCard parent is hovered
	visible = get_visibility()
	
	if get_window().gui_get_hovered_control():
		if get_window().gui_get_hovered_control().get_parent() is EffectCard:
			var hovered_card: EffectCard = get_window().gui_get_hovered_control().get_parent()
			var effect := hovered_card.effect_instance
			%Title.text = effect.title
			%Description.text = effect.description
			size.y = 0.0
			
			update_position_offsets()
