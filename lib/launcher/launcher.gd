extends Control
# Launcher

@onready var current_position: Vector2
var last_mouse_title_click = Vector2.ZERO
var mouse_in_title = false
var moving_window = false

@onready var original_window_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"))
var default_window_size: Vector2
var default_window_pos: Vector2

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
	
	AudioServer.set_bus_volume_db(0, 0)
	$Menu/PlayButton.grab_focus()
	
	# Add sounds to buttons and configure mouse event passing
	for n in Utilities.get_all_children(self):
		if "mouse_filter" in n: n.mouse_filter = MOUSE_FILTER_PASS
		# Connect hover sound effects
		if n is BaseButton or n is Range:
			n.focus_entered.connect(func(): Global.click_sound.emit())
			n.mouse_entered.connect(func(): Global.hover_sound.emit())
	
	# In case the user is orbiting when they return to the launcher
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_window().mode = Window.MODE_WINDOWED
	
	# Record original position and size, and set size/borderless
	get_window().borderless = true
	default_window_size = get_window().size
	default_window_pos = get_window().position
	get_window().size = size * Global.retina_scale
	get_window().position = (DisplayServer.screen_get_size() / 2.0
		- get_window().size / 2.0 + Vector2(0, -100))
	current_position = get_window().position

func _input(event: InputEvent) -> void:
	# Functions for window dragging
	if Input.is_action_just_pressed("left_click"):
		last_mouse_title_click = DisplayServer.mouse_get_position()
		moving_window = true
	# Action release isn't working on macOS (because borderless?)
	if event is InputEventMouseButton:
		if !event.is_pressed():
			moving_window = false
			current_position = get_window().position

func _on_play_button_pressed() -> void:
	# Reset the window to its original state before proceeding
	get_window().size = default_window_size
	get_window().position = default_window_pos
	get_window().borderless = false
	get_tree().change_scene_to_file("res://lib/map/loader/loader.tscn")

func _on_close_pressed() -> void: get_tree().quit()

func _process(_delta: float) -> void:
	# Window movement
	if moving_window:
		var _mouse_delta: Vector2 = DisplayServer.mouse_get_position() - last_mouse_title_click
		get_window().position = current_position + _mouse_delta
