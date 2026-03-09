extends CharacterBody3D

@export_category("Physics")
@export var speed := 3.4
@export var speed_multiplier := 1.0 # used for lethargy etc
@export var friction := 16.0
@export var gravity_damping := 10.0

var _target_velocity := Vector3.ZERO

func _ready() -> void:
	$RobotMesh/AnimationPlayer.play("idle")

func _physics_process(_delta: float) -> void:
	_target_velocity = Vector3.ZERO
	var _camera_basis: Basis = %Orbit.global_transform.basis
	
	# Calculate basis and move player based on player input
	var _basis_x: Vector3 = Vector3.RIGHT * _camera_basis * Vector3(1, 0, -1)
	var _basis_z: Vector3 = Vector3.FORWARD * _camera_basis * Vector3(-1, 0, 1)
	_basis_x = _basis_x.normalized()
	_basis_z = _basis_z.normalized()
	_target_velocity += _basis_z * %InputHandler.direction.z * speed * speed_multiplier
	_target_velocity += _basis_x * %InputHandler.direction.x * speed * speed_multiplier
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	
	# Apply gravity and hover
	var _y_diff: float = %YCast.global_position.y - %YCast.get_collision_point().y
	var _y_target: float = abs(%YCast.target_position.y)
	if !%YCast.is_colliding(): # apply gravity even if beyond raycast height
		_y_diff = _y_target
	velocity.y += Dwelt.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
