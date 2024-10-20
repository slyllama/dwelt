@tool
extends Node3D
const MMOOrbitHandler = preload("res://addons/mmo_camera/orbit_handler.gd")

@export var zoom_increment = 0.3

var mouse_in_ui = false

var _target_zoom = 2.0 # set by the spring length of the axis
var _max_zoom_in = 1.0
var _max_zoom_out = 3.0
var _v_offset_in = 0.56
var _v_offset_out = 1.45

var axis = SpringArm3D.new()
var camera = Camera3D.new()
var orbit_handler = MMOOrbitHandler.new()
var target = Node3D.new()

# Adapt the v_offset of the camera to the zoom level
func _get_v_offset() -> float:
	var ratio = (_target_zoom + _max_zoom_in) / (_max_zoom_out - _max_zoom_in) - 1.0
	return((_v_offset_out - _v_offset_in) * ratio + _v_offset_in)

func _input(event: InputEvent) -> void:
	if event is InputEventPanGesture: _target_zoom += event.delta.y / 2.0
	if Input.is_action_just_pressed("zoom_in"): _target_zoom -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"): _target_zoom += zoom_increment

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	# Configure camera and spring arm
	axis.spring_length = 4.0
	axis.margin = 0.5
	
	# Add components to the scene
	add_child(axis)
	add_child(camera)
	add_child(orbit_handler)
	axis.add_child(target)
	
	# Set up initial characteristics
	orbit_handler.target_rotation = rotation_degrees
	camera.global_position = target.global_position
	axis.spring_length = _target_zoom
	camera.v_offset = _get_v_offset()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	_target_zoom = clamp(_target_zoom, _max_zoom_in, _max_zoom_out)
	var _spring_ratio = axis.get_hit_length() / axis.spring_length
	var _target_v_offset = lerp(camera.v_offset, _get_v_offset() * _spring_ratio, 6.0 * delta)
	
	# Apply camera transformations
	axis.spring_length = lerp(axis.spring_length, _target_zoom, 10.0 * delta)
	camera.position = lerp(camera.position, target.position, 6.0 * delta)
	rotation_degrees = orbit_handler.smooth_rotation
	camera.v_offset = _target_v_offset
