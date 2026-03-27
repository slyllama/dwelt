class_name SettingsCheckButton extends CheckButton

@export var setting_id: String

func _ready() -> void:
	if !setting_id: queue_free()
	
	pressed.connect(func() -> void:
		if button_pressed: Settings.apply_setting(setting_id, "true")
		else: Settings.apply_setting(setting_id, "false"))
	
	if setting_id in Settings.settings:
		var _value: String = Settings.settings[setting_id]
		if _value == "true": button_pressed = true
		elif _value == "false": button_pressed = false
	else:
		queue_free()
