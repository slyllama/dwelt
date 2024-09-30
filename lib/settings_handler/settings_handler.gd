extends Node
# SettingsHandler
# Handles the management and updating of settings

# These will be considered default settings (for now)
var settings = { "fov": 90 }
signal setting_changed(parameter)

# Ping 'setting_changed' for all settings
func refresh() -> void:
	for s in settings:
		setting_changed.emit(s)

func update(parameter, value) -> void:
	settings[parameter] = value
	setting_changed.emit(parameter)
