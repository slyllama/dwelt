extends Marker3D

@export var vertical_offset := 0.4
@export var view_length := 2.0
@export var view_sensitivity := 0.75
@export var zoom_min := 1.0
@export var zoom_max := 3.0
@export var zoom_increment := 0.2

@onready var target_x_rotation := rotation.x
@onready var target_y_rotation := global_rotation.y

var _event_relative := Vector2.ZERO
var _last_click_position := Vector2.ZERO
var _eligible_to_capture := false

func _release(warp_mouse := true) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_eligible_to_capture = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if warp_mouse: get_window().warp_mouse(_last_click_position)

func _ready() -> void:
	# Release focus on window focus lost (without moving the mouse)
	get_window().focus_exited.connect(_release.bind(false))
	
	Dwelt.camera = $Camera
	top_level = true
	$Camera.top_level = true

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("left_click")
		and !get_window().gui_get_hovered_control()):
		_last_click_position = get_window().get_mouse_position()
		_eligible_to_capture = true
	if Input.is_action_just_released("left_click"):
		_release()
	
	if (event is InputEventMouseMotion
		and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		_event_relative = event.relative * view_sensitivity
	
	# Handle zoom
	if Input.is_action_just_pressed("zoom_in"):
		view_length -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		view_length += zoom_increment

func _physics_process(_delta: float) -> void:
	var _last_event_relative := _event_relative
	view_length = clamp(view_length, zoom_min, zoom_max)
	
	# Only enter panning mode once a mouse click-and-drag passes a certain threshold
	if (Input.is_action_pressed("left_click")
		and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		var _mouse_pos := get_window().get_mouse_position()
		var _mouse_delta := _mouse_pos - _last_click_position
		if _mouse_delta.length_squared() > 100.0 and _eligible_to_capture:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Update panning outcomes (even if no user input is happening)
	target_x_rotation -= _event_relative.y * 0.01
	target_y_rotation -= _event_relative.x * 0.01
	target_x_rotation = clamp(
		target_x_rotation, deg_to_rad(-80), deg_to_rad(30))
	rotation.x = lerp_angle(rotation.x,
		target_x_rotation, Utils.crit_lerp(20.0))
	rotation.y = lerp_angle(rotation.y,
		target_y_rotation, Utils.crit_lerp(20.0))
	
	# Handle camera view_length
	$SpringArm.spring_length = lerp($SpringArm.spring_length,
		view_length, Utils.crit_plerp(10.0))
	
	# Update vertical offset
	var _vo_ratio := (view_length - zoom_min) / (zoom_max - zoom_min)
	vertical_offset = 0.2 + _vo_ratio * 0.9
	
	# Update positions
	global_position = lerp(global_position,
		get_parent().global_position + Vector3(0, 1, 0) * vertical_offset,
		Utils.crit_plerp(10.0))
	$Camera.global_position = $SpringArm/CameraAnchor.global_position
	$Camera.global_rotation = $SpringArm/CameraAnchor.global_rotation
	
	if _event_relative == _last_event_relative:
		_event_relative = Vector2.ZERO # prevent runaway orbiting
