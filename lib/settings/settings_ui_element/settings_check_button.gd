class_name SettingsCheckButton extends CheckButton

@export var setting_id: String

# Update UI elements based on settings without applying the settings themselves
func redraw() -> void:
	var _value: String = Settings.settings[setting_id]
	if _value == "true": button_pressed = true
	elif _value == "false": button_pressed = false

func _ready() -> void:
	if !setting_id:
		queue_free()
		return
	
	pressed.connect(func() -> void:
		if button_pressed: Settings.apply_setting(setting_id, "true")
		else: Settings.apply_setting(setting_id, "false"))
	
	# Redraw settings if they are reset
	Settings.settings_reset.connect(redraw)
	
	if setting_id in Settings.settings:
		redraw()
	else: queue_free()
