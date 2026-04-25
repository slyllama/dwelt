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
	get_tree().change_scene_to_file("res://lib/main_menu/main_menu.tscn")

func _on_volume_slider_dragged(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
