@tool
extends UIPane

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	Dwelt.gadgets_close_to_player_changed.connect(func() -> void:
		if Dwelt.gadgets_close_to_player.size() > 0:
			%CloseGadgets.text = "Current nearby gadget: " + str(Dwelt.gadgets_close_to_player[-1]) + "."
		else: %CloseGadgets.text = "Current nearby gadget: none.")

func _on_reset_pos_pressed() -> void: Utils.debug_sent.emit("/resetpos")
func _on_save_gadgets_pressed() -> void: Utils.debug_sent.emit("/savegadgets")
func _on_reload_gadgets_pressed() -> void: Utils.debug_sent.emit("/reloadgadgets")

func _on_debug_overlay_pressed() -> void:
	Utils.debug_mode = !Utils.debug_mode
	Utils.debug_mode_changed.emit()

func _on_debug_effects_pressed() -> void:
	await get_tree().create_timer(0.05).timeout
	Utils.debug_sent.emit("/debugeffects")

func _on_return_pressed() -> void:
	# Reset player/UI elements associated with selecting gadgets
	Dwelt.selected_gadget = null
	Dwelt.selected_gadget_changed.emit(null)
	Dwelt.gadgets_close_to_player = []
	
	Save.save_file()
	get_tree().change_scene_to_file("res://lib/shard/shard_loader/shard_loader.tscn")
