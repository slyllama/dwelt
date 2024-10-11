extends Node3D
# CameraHandler
# Handles player orbiting and camera functions

@export var zoom_increment = 0.3
@export var second_vertical_offset = 0.0

@onready var camera: Camera3D = get_node("Camera")
var _target_zoom = 2.0 # set by the spring length of the axis

var _max_zoom_in = 1.0
var _max_zoom_out = 3.0
var _v_offset_in = 0.56
var _v_offset_out = 1.45

# Adapt the v_offset of the camera to the zoom level
func _get_v_offset() -> float:
	var ratio = (_target_zoom + _max_zoom_in) / (_max_zoom_out - _max_zoom_in) - 1.0
	return((_v_offset_out - _v_offset_in) * ratio + _v_offset_in)

func _ready() -> void:
	# Set up initial characteristics
	$OrbitHandler.target_rotation = rotation_degrees
	camera.global_position = $Axis/Target.global_position
	$Axis.spring_length = _target_zoom
	camera.v_offset = _get_v_offset()
	
	Global.shake_camera.connect(func():
		$Camera/CameraFX.play("shake"))
	
	# Make the camera node global so that other scenes can use unproject_position
	CameraData.camera = camera

func _input(event: InputEvent) -> void:
	if Global.mouse_in_ui() or Global.in_exclusive_ui: return
	if event is InputEventPanGesture: _target_zoom += event.delta.y / 2.0
	if Input.is_action_just_pressed("zoom_in"): _target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"): _target_zoom += zoom_increment

func _process(delta: float) -> void:
	# Zoom smoothing
	_target_zoom = clamp(_target_zoom, _max_zoom_in, _max_zoom_out)
	$Axis.spring_length = lerp(
		$Axis.spring_length, _target_zoom, 10.0 * delta)
	
	# Orbit smoothing
	rotation_degrees = $OrbitHandler.smooth_rotation
	# Position, rotation, and offset smoothing
	camera.position = lerp(camera.position, $Axis/Target.position, 6.0 * delta)
	# Multiply the vertical offset by the ratio of how far down the spring arm
	# the camera is - ensures that the player is always in view even when the
	# camera is heavily constrained in a tight space
	var _spring_ratio = $Axis.get_hit_length() / $Axis.spring_length
	var _target_v_offset = lerp(camera.v_offset, _get_v_offset() * _spring_ratio, 6.0 * delta)
	camera.v_offset = _target_v_offset + second_vertical_offset
	CameraData.facing_angle = global_rotation.y - deg_to_rad(180)
