extends Node

var _delta := 0.0
var _pdelta := 0.0

var debug_mode := false

signal debug_mode_changed
signal debug_sent(string: String)
signal pdebug_sent(string: String)

func crit_lerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func crit_plerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _pdelta), 0.0, 1.0))

func cursor_in_window(padding: float) -> bool:
	var _pos := get_window().get_mouse_position()
	var _size := get_window().size / get_window().content_scale_factor
	var _in_window := true
	if _pos.x < padding or _pos.x > _size.x - padding: _in_window = false
	if _pos.y < padding or _pos.y > _size.y - padding: _in_window = false
	return(_in_window)

# Get all children recursively
func get_all_children(node: Node, arr := []) -> Array:
	arr.push_back(node)
	for _child in node.get_children():
		arr = get_all_children(_child, arr)
	return(arr)

func get_window_center() -> Vector2:
	return(get_window().size / 2.0 / get_window().content_scale_factor)

# Togglable debug printing with class/node prefixes
func pdebug(text: String, source := "") -> void:
	var line := text
	if source != "":
		line = "[" + source + "] " + line
	pdebug_sent.emit(line)
	print(line)

# Convert a vector in string format "X, Y, Z" to a typed Vector3
func str_to_vec3(string: String) -> Vector3:
	var _a: PackedStringArray = string.split(", ")
	if _a.size() != 3: return(Vector3.ZERO) # return 0 if the input size isn't right
	return(Vector3(_a[0].to_float(), _a[1].to_float(), _a[2].to_float()))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_debug_mode"):
		debug_mode = !debug_mode
		debug_mode_changed.emit()

func _process(delta: float) -> void: _delta = delta
func _physics_process(delta: float) -> void: _pdelta = delta
