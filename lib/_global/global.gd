extends Node

signal input_captured
signal input_uncaptured
signal ui_closed

var current_shard := "none"

func request_quit() -> void:
	Utils.pdebug("About to quit!", "Global")
	get_tree().quit()

func update_window_mode(id: String) -> void:
	match id:
		"windowed": get_window().mode = Window.MODE_WINDOWED
		"maximized": get_window().mode = Window.MODE_MAXIMIZED
		"exclusive_full_screen": get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		_: get_window().mode = Window.MODE_FULLSCREEN

func _ready() -> void:
	SettingsHandler.applied.connect(func(_settings):
		if "window_mode" in _settings:
			update_window_mode(_settings["window_mode"]))
	
	if DisplayServer.screen_get_size().x > 2000:
		get_window().content_scale_factor = 2.0 # retina
		DisplayServer.cursor_set_custom_image(load(
			"res://generic/textures/cursor_2x.png"))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		request_quit()
