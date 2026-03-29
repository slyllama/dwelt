extends CanvasLayer

const SettingsPane = preload("res://lib/settings/settings_pane/settings_pane.tscn")

func _ready() -> void:
	$DebugBG.queue_free()
	await get_tree().create_timer(0.1).timeout
	%EyesAnim.animate()

func _on_settings_pressed() -> void:
	# Close original pane if it is open
	for _n: UIPane in %UIPaneManager.get_children():
		if _n.ui_id == "settings_pane":
			%UIPaneManager.close_pane(_n)
	
	var settings_pane: UIPane = SettingsPane.instantiate()
	%UIPaneManager.add_child(settings_pane)
	settings_pane.set_anchors_preset(Control.PRESET_CENTER)
	settings_pane.move_to_center()

func _on_quit_pressed() -> void:
	Save.save_file()
	get_tree().quit()
