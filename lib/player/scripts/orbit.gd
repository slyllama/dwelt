extends Marker3D

@export var orbit_speed := 0.35
@export var orbit_smoothing := 30.0

var event_relative := Vector2.ZERO
var last_event_relative := event_relative
@onready var _target_orbit_x_rotation: float = rotation.x
@onready var _target_orbit_y_rotation: float = rotation.y

func _capture_input(force := false) -> void:
	# Don't capture when clicking on UI
	if !force:
		if get_window().gui_get_hovered_control(): return
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.input_captured.emit()

func _uncapture_input() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.input_uncaptured.emit()

func _ready() -> void:
	get_window().focus_exited.connect(_uncapture_input)
	Global.ui_closed.connect(func(): _capture_input(true))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"): _uncapture_input()
	if Input.is_action_just_pressed("left_click"): _capture_input()
	if Input.is_action_just_pressed("right_click"): _capture_input()
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			event_relative = event.relative

func _physics_process(delta: float) -> void:
	if event_relative == last_event_relative:
		event_relative = Vector2.ZERO
	
	_target_orbit_x_rotation -= event_relative.y * delta * orbit_speed
	_target_orbit_y_rotation -= event_relative.x * delta * orbit_speed
	_target_orbit_x_rotation = clamp(_target_orbit_x_rotation,
		deg_to_rad(-70.0), deg_to_rad(70.0))
	
	rotation.x = lerp(rotation.x, _target_orbit_x_rotation, delta * orbit_smoothing)
	rotation.y = lerp(rotation.y, _target_orbit_y_rotation, delta * orbit_smoothing)
	last_event_relative = event_relative
