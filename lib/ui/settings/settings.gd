extends "res://lib/ui/ui_container/ui_container.gd"
# Settings

func close():
	SettingsHandler.save_to_file()
	super()

func _ready():
	super()
	# Use set_value_no_signal(value) to configure without re-triggering settings updates
	SettingsHandler.setting_changed.connect(func(parameter):
		var _value = SettingsHandler.settings[parameter]
		match parameter:
			"fov":
				$Container/FOVTitle.text = ("Field of view: "
					+ str(_value) + Utilities.DEG)
				$Container/FOV.set_value_no_signal(_value)
			"brightness":
				$Container/Brightness.set_value_no_signal(_value)
	)
	$Container/MinimapTool.modulate = Color.ORANGE

# Open with a hotkey
func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("settings"):
		if !is_open: open()
		else: close()

func _physics_process(_delta: float) -> void:
	# Display some more debug data, because we can
	$Container/PlayerPos.text = "(" + Utilities.fmt_vec3(Global.player_position) + ")"
	$Container/PlayerPos.text += (" "
		+ str(snapped(rad_to_deg(CameraData.facing_angle), 1)) + Utilities.DEG)

# Panel connections
func _on_fov_value_changed(value: float) -> void:
	SettingsHandler.update("fov", value)

func _on_brightness_value_changed(value: float) -> void:
	SettingsHandler.update("brightness", value)

func _on_minimap_tool_pressed() -> void:
	get_parent().get_node_or_null("MinimapTool").open()

func _on_reset_settings_pressed() -> void:
	SettingsHandler.reset()

func _on_close_pressed() -> void:
	close()
	get_tree().quit()
