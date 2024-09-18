extends Node3D
# CameraHandler
# Handles player orbiting and camera functions

@export var orbit_sensitivity := 0.3
@export var orbit_smoothing := 12.0
@export var zoom_increment := 0.3

@onready var camera: Camera3D = get_node("Camera")
var orbiting = false
var _target_rotation = Vector3.ZERO
var _mouse_delta = Vector2.ZERO # event.relative
var _target_zoom = 2.0 # set by the spring length of the axis
var _last_click_position = Vector2.ZERO

var _max_zoom_in = 1.0
var _max_zoom_out = 3.0
var _v_offset_in = 0.2
var _v_offset_out = 1.0

# Adapt the v_offset of the camera to the zoom level
func _get_v_offset() -> float:
	var ratio = (_target_zoom + _max_zoom_in) / (_max_zoom_out - _max_zoom_in) - 1.0
	return((_v_offset_out - _v_offset_in) * ratio + _v_offset_in)

func _ready() -> void:
	# Set up initial characteristics
	_target_rotation = rotation_degrees
	camera.global_position = $Axis/Target.global_position
	$Axis.spring_length = _target_zoom
	camera.v_offset = _get_v_offset()
	
	get_window().focus_exited.connect(func():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		orbiting = false)
	
	# Make the camera node global so that other scenes can use unproject_position
	CameraData.camera = camera

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_last_click_position = get_window().get_mouse_position()
	if Input.is_action_just_released("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		orbiting = false
	
	if Input.is_action_just_pressed("zoom_in"):
		_target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		_target_zoom += zoom_increment
	
	if event is InputEventMouseMotion:
		_mouse_delta = event.relative

func _process(delta: float) -> void:
	# Only enter orbit mode after dragging the screen a certain amount i.e., not instantly
	if !orbiting and Input.is_action_pressed("left_click"):
		var _mouse_offset = get_window().get_mouse_position() - _last_click_position
		if abs(_mouse_offset.x) > 5 or abs(_mouse_offset.y) > 5:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			orbiting = true
	
	# Process relative mouse movement (_mouse_delta)
	# This is handled here instead of _input() because handling without delta
	# causes strange behaviour at low frame rates
	if orbiting:
		_target_rotation.y -= _mouse_delta.x * orbit_sensitivity * delta * 100.0
		_target_rotation.x -= _mouse_delta.y * orbit_sensitivity * delta * 100.0
		_target_rotation.x = clamp(_target_rotation.x, -40.0, 60.0)
	_mouse_delta = Vector2.ZERO
	
	# Zoom smoothing
	_target_zoom = clamp(_target_zoom, _max_zoom_in, _max_zoom_out)
	$Axis.spring_length = lerp(
		$Axis.spring_length, _target_zoom, 10.0 * delta)
	
	# Orbit smoothing
	if _target_rotation != null:
		rotation_degrees = lerp(
			rotation_degrees, _target_rotation, orbit_smoothing * delta)
	
	# Position, rotation, and offset smoothing
	camera.position = lerp(camera.position, $Axis/Target.position, 6.0 * delta)
	camera.v_offset = lerp(camera.v_offset, _get_v_offset(), 6.0 * delta)
	CameraData.camera_y_rotation = global_rotation.y
