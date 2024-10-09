class_name OrbitHandler extends Node
# OrbitHandler
# Handles getting mouse drag events for orbiting

@export var orbit_sensitivity := 0.3
@export var orbit_smoothing := 12.0
@export var override_eligibility := false

@export_category("Clamping")
@export var clamp_x := true
@export var clamp_x_lower := -65.0
@export var clamp_x_upper := 10.0
@export var clamp_y := false
@export var clamp_y_lower := -180.0
@export var clamp_y_upper := 180.0

var orbiting = false
var target_rotation = Vector3.ZERO
var smooth_rotation = Vector3.ZERO

var _mouse_delta = Vector2.ZERO # event.relative
var _last_click_position = Vector2.ZERO
# If a click and drag is initiated in the map, the drag will not influence camera
# orbiting until release
var _clicked_in_ui = false

func set_initial_rotation(rotation: Vector3) -> void:
	target_rotation = rotation
	smooth_rotation = rotation

func _ready() -> void:
	get_window().focus_exited.connect(func():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		orbiting = false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		if Global.mouse_in_ui():
			_clicked_in_ui = true
		else:
			get_viewport().gui_release_focus()
		_last_click_position = get_window().get_mouse_position()
	if Input.is_action_just_released("left_click"):
		_clicked_in_ui = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		orbiting = false
	
	if event is InputEventMouseMotion:
		_mouse_delta = event.relative

func _process(delta: float) -> void:
	if Global.in_cutscene and !override_eligibility: return
	
	# Only enter orbit mode after dragging the screen a certain amount i.e., not instantly
	if (!orbiting and !_clicked_in_ui and Input.is_action_pressed("left_click")
		and !Global.popup_open):
		var _mouse_offset = get_window().get_mouse_position() - _last_click_position
		if abs(_mouse_offset.x) > 5 or abs(_mouse_offset.y) > 5:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			orbiting = true
	
	# Process relative mouse movement (_mouse_delta)
	# This is handled here instead of _input() because handling without delta
	# causes strange behaviour at low frame rates
	if orbiting:
		target_rotation.x -= _mouse_delta.y * orbit_sensitivity * delta * 100.0
		if clamp_x: target_rotation.x = clamp(target_rotation.x, clamp_x_lower, clamp_x_upper)
		target_rotation.y -= _mouse_delta.x * orbit_sensitivity * delta * 100.0
		if clamp_y: target_rotation.y = clamp(target_rotation.y, clamp_y_lower, clamp_y_upper)
	smooth_rotation = lerp(smooth_rotation, target_rotation, delta * orbit_smoothing)
	_mouse_delta = Vector2.ZERO
