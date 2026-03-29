extends Node
# Settings manager/bus

const SETTINGS_PATH := "user://settings.json"
const DEFAULT_SETTINGS := {
	"bloom": "true",
	"colour_grading": "true",
	"full_screen": "true",
	"shadows": "high",
	"draw_distance": "medium"
}

@onready var settings := DEFAULT_SETTINGS.duplicate()

signal setting_applied(parameter: String, value: String)
signal settings_reset

# Apply a setting, but only if it exists in the settings file (so individual
# nodes don't have to do their own checks)
func apply_setting(parameter: String, value: String) -> void:
	if parameter in settings:
		settings[parameter] = value
		setting_applied.emit(parameter, value)
	else: Utils.pdebug("Couldn't save setting '"
		+ parameter + "': no such setting.", "Settings")
	save_file()

func apply_all_settings() -> void:
	for _s: String in settings:
		apply_setting(_s, settings[_s])
		setting_applied.emit(_s, settings[_s])

func apply_default_settings() -> void:
	settings = DEFAULT_SETTINGS.duplicate()
	save_file()
	apply_all_settings()
	settings_reset.emit()

func load_file() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var _f := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var _f_json: Dictionary = JSON.parse_string(_f.get_as_text())
		# Update values in `settings` rather than replacing the whole thing -
		# ensures that new values are appropriately added to the save
		for parameter: String in _f_json:
			# Only values already in `DEFAULT_SETTINGS` get updated
			if parameter in DEFAULT_SETTINGS:
				settings[parameter] = _f_json[parameter]
		_f.close()

func save_file() -> void:
	var _f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	_f.store_string(JSON.stringify(settings, "\t"))
	_f.close()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_file()
	save_file()
