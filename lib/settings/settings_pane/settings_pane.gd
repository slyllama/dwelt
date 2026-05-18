@tool
extends UIPane

func _on_ready() -> void:
	await get_tree().process_frame
	%Done.grab_focus()

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
