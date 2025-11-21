extends Node

var direction = Vector3.ZERO
var _last_x_input: Array[int] = []
var _last_z_input: Array[int] = []

func is_input_down() -> bool:
	if _last_x_input.size() > 0 or _last_z_input.size() > 0:
		return(true)
	else: return(false)

func _ready() -> void:
	get_window().focus_exited.connect(func():
		# Clear input if window focus is lost
		_last_x_input = []
		_last_z_input = [])

func _input(event: InputEvent) -> void:
	# Push input actions onto a stack so that if key A is held, then key B is
	# pressed and released, key A's input action will continue
	if Input.is_action_just_pressed("move_left"): _last_x_input.push_front(-1)
	if Input.is_action_just_pressed("move_right"): _last_x_input.push_front(1)
	if Input.is_action_just_released("move_left"): _last_x_input.erase(-1)
	if Input.is_action_just_released("move_right"): _last_x_input.erase(1)
	
	if Input.is_action_just_pressed("move_forward"): _last_z_input.push_front(1)
	if Input.is_action_just_pressed("move_back"): _last_z_input.push_front(-1)
	if Input.is_action_just_released("move_forward"): _last_z_input.erase(1)
	if Input.is_action_just_released("move_back"): _last_z_input.erase(-1)
	
	# Clear input in instances where two keys are released at once
	if event is InputEventKey:
		if (!Input.is_action_pressed("move_left")
			and !Input.is_action_pressed("move_right")):
			_last_x_input = []
		if (!Input.is_action_pressed("move_forward")
			and !Input.is_action_pressed("move_back")):
			_last_z_input = []

func _physics_process(_delta: float) -> void:
	# Retrieve directions from input stacks
	var _dir = Vector3.ZERO
	if _last_x_input.size() > 0:
		_dir.x = _last_x_input[0]
	else: _dir.x = 0
	if _last_z_input.size() > 0:
		_dir.z = _last_z_input[0]
	else: _dir.z = 0
	direction = _dir.normalized()
