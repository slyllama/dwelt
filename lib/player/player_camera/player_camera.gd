extends Node3D
# PlayerCamera
# Camera controls and rotation

@export_range(0.0, 1.0) var orbit_speed = 0.35
@export_range(10.0, 40.0) var orbit_sensitivity = 20.0
@export var zoom_increment = 0.35
@export var zoom_clamp_near = 1.0
@export var zoom_clamp_far = 5.0

var _mouse_last_click = Vector2.ZERO # where the mouse was last clicked
var _mouse_pos_delta = Vector2.ZERO # reports event.relative
var _last_mouse_pos_delta = _mouse_pos_delta # used to check if mouse is moving
var _mouse_last_in_ui = false # whether the mouse was in UI when last pressed down

@onready var target_x_rotation = $Axis.global_rotation.x
@onready var target_y_rotation = global_rotation.y
@onready var target_zoom_distance = $Axis/Camera.position.z

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		_mouse_last_in_ui = Reporter.mouse_in_ui
		_mouse_last_click = get_window().get_mouse_position()
	
	if _mouse_last_in_ui: return
	
	if Input.is_action_just_released("left_click"):
		# Move the mouse to its last position before dragging
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Reporter.orbiting = false
		get_window().warp_mouse(_mouse_last_click)
	
	if Input.is_action_pressed("left_click"):
		if event is InputEventMouseMotion:
			_mouse_pos_delta = event.relative
			if _mouse_pos_delta.length() > 0:
				# Only capture the mouse if the player is dragging it
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_viewport().gui_release_focus()
				Reporter.orbiting = true
	else: _mouse_pos_delta = Vector2.ZERO
	
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom_distance -= zoom_increment
	if Input.is_action_just_pressed("zoom_out"):
		target_zoom_distance += zoom_increment

func _ready() -> void:
	Reporter.do_shake_camera.connect(func(): $Anim.play("shake"))
	Reporter.player.focus_mode_entered.connect(func(): target_zoom_distance -= 0.5)
	Reporter.player.focus_mode_exited.connect(func(): target_zoom_distance += 0.5)
	
	Reporter.camera = $Axis/Camera # assign camera to Reporter

func _process(delta: float) -> void:
	if _mouse_last_in_ui: return
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
		and _last_mouse_pos_delta != _mouse_pos_delta):
		target_y_rotation -= _mouse_pos_delta.x * delta * orbit_speed
		target_x_rotation -= _mouse_pos_delta.y * delta * orbit_speed
	
	# Prevent the camera's rotation from 'spilling over'
	target_x_rotation = clamp(
		target_x_rotation, -deg_to_rad(89), deg_to_rad(-30))
	
	# Clamp zoom distances
	target_zoom_distance = clamp(
		target_zoom_distance, zoom_clamp_near, zoom_clamp_far)
	
	# Smooth and update camera rotation
	$Axis.global_rotation.x = lerp_angle(
		$Axis.global_rotation.x, target_x_rotation,
		Utils.crit_lerp(delta, orbit_sensitivity))
	
	# Smooth and update camera zoom
	$Axis/Camera.position.z = lerp(
		$Axis/Camera.position.z, target_zoom_distance,
		Utils.crit_lerp(delta, 10.0))
	
	# Only update camera rotation if the mouse delta has changed
	_last_mouse_pos_delta = _mouse_pos_delta
