@tool
extends UIPane

var last_clicked_gadget: Gadget

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	Dwelt.gadgets_close_to_player_changed.connect(func() -> void:
		if Dwelt.gadgets_close_to_player.size() > 0:
			%CloseGadgets.text = "Current nearby gadget: " + str(Dwelt.gadgets_close_to_player[-1]) + "."
		else: %CloseGadgets.text = "Current nearby gadget: none.")
	
	Dwelt.gadget_clicked.connect(func(gadget: Gadget) -> void:
		if gadget:
			%Delete.disabled = false
			%Move.disabled = false
			last_clicked_gadget = gadget
		else:
			%Delete.disabled = true
			%Move.disabled = true
			last_clicked_gadget = null)

func _on_reset_pos_pressed() -> void: Utils.debug_sent.emit("/resetpos")
func _on_save_gadgets_pressed() -> void: Utils.debug_sent.emit("/savegadgets")
func _on_reload_gadgets_pressed() -> void: Utils.debug_sent.emit("/reloadgadgets")

func _on_debug_overlay_pressed() -> void:
	Utils.debug_mode = !Utils.debug_mode
	Utils.debug_mode_changed.emit()

func _on_debug_effects_pressed() -> void:
	await get_tree().create_timer(0.05).timeout
	Utils.debug_sent.emit("/debugeffects")

func _on_delete_pressed() -> void:
	if last_clicked_gadget:
		if Dwelt.selected_gadget == last_clicked_gadget:
			Dwelt.update_selected_gadget(null)
		last_clicked_gadget.tree_exited.connect(Save.save_file)
		last_clicked_gadget.queue_free()
		Dwelt.gadget_clicked.emit(null)

func _on_move_pressed() -> void:
	if last_clicked_gadget:
		var _gizmo_mover_group: Node3D = load(
			"res://bops/gizmo/gizmo_mover_group/gizmo_mover_group.tscn").instantiate()
		last_clicked_gadget.add_child(_gizmo_mover_group)
