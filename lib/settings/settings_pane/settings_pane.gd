@tool
extends UIPane

func _on_default_pressed() -> void:
	Settings.apply_default_settings()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_dragged(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_done_pressed() -> void:
	close_pane()

func _on_mapping_pane_pressed() -> void:
	var MappingPane: PackedScene = load("res://lib/settings/mapping_pane/mapping_pane.tscn")
	var _mapping_pane: UIPane = MappingPane.instantiate()
	Dwelt.ui_pane_manager.add_child(_mapping_pane)
	_mapping_pane.move_to_center()
