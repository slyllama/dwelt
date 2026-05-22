@tool
extends UIPane

func _on_default_pressed() -> void:
	Settings.apply_default_settings()

func _on_quit_pressed() -> void:
	Save.save_file()
	get_tree().quit()

func _on_menu_pressed() -> void:
	# Reset player/UI elements associated with selecting gadgets
	Dwelt.selected_gadget = null
	Dwelt.selected_gadget_changed.emit(null)
	Dwelt.gadgets_close_to_player = []
	
	Save.save_file()
	
	# prevent a race condition with UIPane 'click' checks in UIPaneManager
	for _i in 3: await get_tree().process_frame
	get_tree().change_scene_to_file("res://lib/main_menu/main_menu.tscn")

func _on_volume_slider_dragged(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_done_pressed() -> void:
	close_pane()

func _on_full_screen_pressed() -> void:
	for _i in 3: await get_tree().process_frame
	if Input.get_connected_joypads().size() > 0:
		DweltInput.current_device_mode = DweltInput.DeviceModes.CONTROLLER
		DweltInput.current_device_changed.emit()

func _on_mapping_pane_pressed() -> void:
	var MappingPane: PackedScene = load("res://lib/settings/mapping_pane/mapping_pane.tscn")
	var _mapping_pane: UIPane = MappingPane.instantiate()
	Dwelt.ui_pane_manager.add_child(_mapping_pane)
	_mapping_pane.move_to_center()
