extends Camera3D
# Make player model float around and smoothly follow mouse cursor

@export var smoothness := 5.0
@export var intensity := Vector2(1.0, 1.0)
@onready var original_position := global_position

var mouse_in_window := true
var last_mouse_delta := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var _mouse_pos := get_window().get_mouse_position()
	# Adjusted window size to take content scaling into account
	var _window_size := get_window().size / get_window().content_scale_factor
	
	var _mouse_delta: Vector2
	if mouse_in_window:
		_mouse_delta = _mouse_pos / _window_size - Vector2(0.5, 0.5)
	else:
		_mouse_delta = last_mouse_delta # don't update if the mouse isn't in the window
	_mouse_delta = clamp(_mouse_delta, Vector2(-0.5, -0.5), Vector2(0.5, 0.5))
	var _translated_delta := Vector3(
		-_mouse_delta.x * intensity.x,
		_mouse_delta.y * intensity.y, 0)
	
	global_position = lerp(global_position,
		original_position + _translated_delta, DwUtils.crit_plerp(5.0))

func _notification(what: int) -> void:
	# Detect whether the mouse is in the window
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		mouse_in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		mouse_in_window = false
