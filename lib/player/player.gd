class_name DweltPlayer extends CharacterBody3D

@export_range(0.0, 10.0) var speed = 3.2
@export var speed_focus_multiplier = 0.5

var focus_mode = false
signal focus_mode_entered
signal focus_mode_exited

var _direction = Vector3.ZERO
var _target_velocity = Vector3.ZERO

func _ready() -> void:
	get_window().focus_exited.connect(func():
		focus_mode_exited.emit()
		focus_mode = false)
	
	Reporter.player = self

func _input(_event) -> void:
	if Input.is_action_just_pressed("right_click"):
		focus_mode_entered.emit()
		focus_mode = true
	elif Input.is_action_just_released("right_click"):
		focus_mode_exited.emit()
		focus_mode = false

func _physics_process(delta: float) -> void:
	# Apply focus mode speed, if it is enabled
	var _speed = speed
	if focus_mode: _speed *= speed_focus_multiplier
	
	# Handle inputs
	if Input.is_action_pressed("move_forward"): _direction.x = 1.0
	elif Input.is_action_pressed("move_back"): _direction.x = -1.0
	else: _direction.x = 0.0
	if Input.is_action_pressed("strafe_left"): _direction.z = -1.0
	elif Input.is_action_pressed("strafe_right"): _direction.z = 1.0
	else: _direction.z = 0.0

	$PlayerModel.update_anim_targets(_direction.x, _direction.z)
	
	_direction = _direction.normalized()
	_direction *= _speed
	
	_target_velocity = (Vector3.FORWARD * _direction.x)
	_target_velocity += (Vector3.RIGHT * _direction.z)
	_target_velocity.y += 2.0 * -98.0 * delta # apply gravity
	
	velocity = lerp(velocity, _target_velocity, Utils.crit_lerp(26.0))
	move_and_slide()
	
	Reporter.player_position = global_position
