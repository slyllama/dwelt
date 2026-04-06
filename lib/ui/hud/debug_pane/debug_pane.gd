@tool
extends UIPane

func _on_reset_pos_pressed() -> void: Utils.debug_sent.emit("/resetpos")
func _on_save_gadgets_pressed() -> void: Utils.debug_sent.emit("/savegadgets")
func _on_reload_gadgets_pressed() -> void: Utils.debug_sent.emit("/reloadgadgets")

func _on_debug_overlay_pressed() -> void:
	Utils.debug_mode = !Utils.debug_mode
	Utils.debug_mode_changed.emit()

func _on_debug_effects_pressed() -> void:
	await get_tree().create_timer(0.05).timeout
	Utils.debug_sent.emit("/debugeffects")
