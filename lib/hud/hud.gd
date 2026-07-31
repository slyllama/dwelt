extends CanvasLayer

const SETTINGS_PANE_PATH := "res://lib/settings/settings_pane/settings_pane.tscn"

func apply_skill(skill_id: String) -> void:
	match skill_id:
		"build":
			DwGlobal.ui_pane_manager.toggle_open(
				"res://lib/ui/ops_pane/ops_pane.tscn", "ops_pane")

func _ready() -> void:
	DwGlobal.skill_used.connect(apply_skill)
	
	$DebugBG.queue_free()
	await get_tree().create_timer(0.1).timeout
	%EyesAnim.animate()

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_cancel")
		and %UIPaneManager.panes.size() == 0):
		_on_settings_pressed()

# Toggle the settings menu
func _on_settings_pressed() -> void:
	%UIPaneManager.toggle_open(SETTINGS_PANE_PATH, "settings_pane")

func _on_screenshot_pressed() -> void:
	if !Input.is_action_pressed("ui_shift"):
		visible = false
		for _i in 2: await get_tree().process_frame
	%ScreenshotManager.take_screenshot()
	visible = true

# Right-click on the screenshot icon to go to the screenshot folder
func _on_screenshot_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		DwGlobal.emit_click_sound.emit()
		%ScreenshotManager.open_folder()
