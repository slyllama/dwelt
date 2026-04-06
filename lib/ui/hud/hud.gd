extends CanvasLayer

const SettingsPane = preload("res://lib/settings/settings_pane/settings_pane.tscn")
const DebugPane = preload("res://lib/ui/hud/debug_pane/debug_pane.tscn")

func _ready() -> void:
	$DebugBG.queue_free()
	await get_tree().create_timer(0.1).timeout
	%EyesAnim.animate()
	
	%PlayerEffects.effect_manager = Dwelt.player_effect_manager

# Toggle the settings menu
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

func _on_screenshot_pressed() -> void:
	if !Input.is_action_pressed("ui_shift"):
		visible = false
		for _i in 2: await get_tree().process_frame
	%ScreenshotManager.take_screenshot()
	visible = true

# Right-click on the screenshot icon to go to the screenshot folder
func _on_screenshot_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		Dwelt.click_sound_requested.emit()
		%ScreenshotManager.open_folder()

func _on_dev_menu_pressed() -> void:
	if !%UIPaneManager.close_pane_by_id("debug_pane"):
		var debug_pane: UIPane = DebugPane.instantiate()
		%UIPaneManager.add_child(debug_pane)
		debug_pane.set_anchors_preset(Control.PRESET_CENTER)
		debug_pane.position += Vector2(100, 100)
