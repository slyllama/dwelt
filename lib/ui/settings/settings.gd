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
				$Container/HFOV/FOVTitle.text = ("FOV ("
					+ str(_value) + Utilities.DEG + ")")
				$Container/HFOV/FOV.set_value_no_signal(_value)
			"music_vol":
				$Container/HMusicVol/MusicVolTitle.text = ("Music ("
					+ str(snapped(_value, 1)) + "%)")
				$Container/HMusicVol/MusicVol.set_value_no_signal(_value)
			"orbit_sensitivity":
				$Container/HOrbitSens/OrbitSens.set_value_no_signal(_value)
	)
	$Container/MinimapTool.modulate = Color.ORANGE
	
	# Show or hide special utility buttons according to the debug visibility settings
	Global.debug_visible_toggled.connect(func():
		$Container/MinimapTool.visible = Global.debug_visible
		$Container/PlayerPos.visible = Global.debug_visible)
	
	Global.set_display_debug(false)

# Open with a hotkey
func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("settings"):
		if !is_open and !Global.in_cutscene: open()
		else: close()

func _physics_process(_delta: float) -> void:
	# Display some more debug data, because we can
	$Container/PlayerPos.text = "(" + Utilities.fmt_vec3(Global.player_position) + ")"
	$Container/PlayerPos.text += (" "
		+ str(snapped(rad_to_deg(CameraData.facing_angle), 1)) + Utilities.DEG)

# Panel connections
func _on_fov_value_changed(value: float) -> void:
	SettingsHandler.update("fov", value)

func _on_minimap_tool_pressed() -> void:
	get_parent().get_node_or_null("MinimapTool").open()

func _on_reset_settings_pressed() -> void:
	SettingsHandler.reset()

func _on_music_vol_value_changed(value: float) -> void:
	SettingsHandler.update("music_vol", value)

func _on_exit_to_launcher_pressed() -> void:
	get_tree().change_scene_to_file("res://lib/launcher/launcher.tscn")

func _on_orbit_sens_value_changed(value: float) -> void:
	SettingsHandler.update("orbit_sensitivity", value)
