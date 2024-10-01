extends Node
# SettingsHandler
# Handles the management and updating of settings
const FILE_PATH = "user://settings.dat"
const DEFAULT_SETTINGS = { 
	"fov": 90,
	"brightness": 1.0
}
@onready var settings = DEFAULT_SETTINGS.duplicate()
signal setting_changed(parameter)

func load_from_file() -> void:
	if FileAccess.file_exists(FILE_PATH):
		var file = FileAccess.open(FILE_PATH, FileAccess.READ)
		settings = file.get_var()

func save_to_file() -> void:
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(settings)

func reset() -> void:
	settings = DEFAULT_SETTINGS.duplicate()
	refresh()
	save_to_file()

# Ping 'setting_changed' for all settings
func refresh() -> void:
	for s in settings:
		setting_changed.emit(s)

func update(parameter, value) -> void:
	settings[parameter] = value
	setting_changed.emit(parameter)

func _ready() -> void:
	load_from_file()
