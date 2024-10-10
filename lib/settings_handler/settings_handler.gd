extends Node
# SettingsHandler
# Handles the management and updating of settings
const FILE_PATH = "user://settings.dat"
const DEFAULT_SETTINGS = { 
	"fov": 90,
	"particle_density": "high",
	"window_mode": "windowed",
	"shadows": "on",
	"music_vol": 50, # percent
	"orbit_sensitivity": 100
}
@onready var settings = DEFAULT_SETTINGS.duplicate()
signal setting_changed(parameter)

@onready var original_window_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"))

func load_from_file() -> void:
	if FileAccess.file_exists(FILE_PATH):
		var file = FileAccess.open(FILE_PATH, FileAccess.READ)
		var _file_settings = file.get_var()
		# Update from a full template rather than replacing it - means that if
		# another setting is added, an old config file without it won't
		# overwrite it
		for f in _file_settings:
			if f in settings:
				settings[f] = _file_settings[f]

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
	# Configure retina
	if DisplayServer.screen_get_size().x > 2000:
		get_window().size = original_window_size * 2.0
		get_window().content_scale_factor = 2.0
		Global.retina_scale = 2.0
		# macOS already configures the cursor for retina
		if OS.get_name() != "macOS":
			DisplayServer.cursor_set_custom_image(
				load("res://generic/textures/cursor_2x.png"))
	
	load_from_file()
