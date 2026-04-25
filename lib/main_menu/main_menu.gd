extends CanvasLayer

const SettingsPane = preload("res://lib/settings/settings_pane/settings_pane.tscn")

func _ready() -> void:
	DiscordRPC.details = "In Menu"
	DiscordRPC.refresh()
	
	%Play.grab_focus()

func _on_play_pressed() -> void:
	Dwelt.shard_path_to_load = "res://shards/acidfields/acidfields.tscn"
	get_tree().change_scene_to_file("res://lib/shard/shard_loader/shard_loader.tscn")

func _on_play_debug_pressed() -> void:
	Dwelt.shard_path_to_load = "res://shards/debug/debug.tscn"
	get_tree().change_scene_to_file("res://lib/shard/shard_loader/shard_loader.tscn")

func _on_settings_pressed() -> void:
	var _pane_open := false
	for _n: UIPane in %UIPaneManager.get_children():
		if _n.ui_id == "settings_pane":
			_pane_open = true
			%UIPaneManager.close_pane(_n)
	if !_pane_open:
		var settings_pane: UIPane = SettingsPane.instantiate()
		%UIPaneManager.add_child(settings_pane)
		settings_pane.set_anchors_preset(Control.PRESET_CENTER)
		settings_pane.move_to_center()
		# Don't return to the menu while in the menu
		settings_pane.get_node("Box/Menu").visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
