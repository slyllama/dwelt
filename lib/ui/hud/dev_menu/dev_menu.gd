extends VBoxContainer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if get_window().gui_get_hovered_control() != self:
			visible = false

func _ready() -> void:
	for node: Control in get_children():
		if node is Button:
			node.pressed.connect(func() -> void:
				visible = false)

func _on_save_gadgets_pressed() -> void:
	Utils.debug_sent.emit("/savegadgets")

func _on_load_gadgets_pressed() -> void:
	Utils.debug_sent.emit("/reloadgadgets")

func _on_reset_player_pos_pressed() -> void:
	Utils.debug_sent.emit("/resetpos")

func _on_effects_pane_pressed() -> void:
	await get_tree().create_timer(0.05).timeout
	Utils.debug_sent.emit("/debugeffects")
