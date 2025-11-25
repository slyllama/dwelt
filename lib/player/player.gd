extends CharacterBody3D

@export var speed := 1.35
@export var sprint_multiplier := 1.6
@export var friction := 36.0
@onready var true_speed := speed

var _target_velocity := Vector3.ZERO
var _target_fov := 90.0
var _moving := false

func _start_sprint() -> void: true_speed = speed * sprint_multiplier
func _stop_sprint() -> void: true_speed = speed

func _ready() -> void:
	get_window().focus_exited.connect(_stop_sprint)
	
	# Smooth reset of animations
	$Orbit/Camera/Anim.set_blend_time("bob", "RESET", 0.35)
	$Orbit/Camera/Anim.set_blend_time("RESET", "bob", 0.35)

func _input(_event: InputEvent) -> void:
	# Toggle sprinting by holding right-click
	if Input.is_action_just_pressed("sprint"): _start_sprint()
	elif Input.is_action_just_released("sprint"): _stop_sprint()

func _physics_process(_delta: float) -> void:
	_target_velocity = Vector3.ZERO
	_target_fov = 90.0
	
	var _camera_basis = $Orbit.global_transform.basis
	
	# Calculate basis and move player based on player input
	var _basis_x: Vector3 = Vector3.RIGHT * _camera_basis * Vector3(1, 0, -1)
	var _basis_z: Vector3 = Vector3.FORWARD * _camera_basis * Vector3(-1, 0, 1)
	_basis_x = _basis_x.normalized()
	_basis_z = _basis_z.normalized()
	_target_velocity += _basis_z * %InputHandler.direction.z * true_speed
	_target_velocity += _basis_x * %InputHandler.direction.x * true_speed * 2.0
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	velocity.y -= 0.98 # gravity
	move_and_slide()
	
	# Logic if the player is moving
	if Vector3(velocity * Vector3(1, 0, 1)).length() > 1.0:
		if true_speed > speed:
			_target_fov = 95.0 # increase FOV for sprinting
		if !_moving:
			$Orbit/Camera/Anim.play("bob")
			$StepHandler.mute(false)
			_moving = true
	else:
		if _moving:
			$Orbit/Camera/Anim.play("RESET")
			$StepHandler.mute()
			_moving = false
	
	$Orbit/Camera.fov = lerp(
		$Orbit/Camera.fov, _target_fov, Utils.crit_plerp(9.0))
