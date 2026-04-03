class_name DweltPlayer extends CharacterBody3D

@export_category("Physics")
@export var speed := 2.0
@export var speed_multiplier := 1.0 # used for lethargy etc
@export var friction := 15.0
@export var gravity_damping := 10.0

var _target_velocity := Vector3.ZERO
var _target_y_rotation := 0.0
var _target_y_position := 0.0

var _moving := false
signal move_started
signal move_stopped

@onready var _initial_y_rotation: float = %Orbit.rotation.y

func _ready() -> void:
	#Dwelt.player = self
	Dwelt.player_effect_manager = %EffectManager
	
	%Motes.visible = true
	move_started.connect(func() -> void: $RobotMesh/Sound.move_vol = 0.37)
	move_stopped.connect(func() -> void: $RobotMesh/Sound.move_vol = 0.0)
	
	%EffectManager.add_effect(load("res://effects/resilience.tres"))

func _physics_process(_delta: float) -> void:
	_target_velocity = Vector3.ZERO
	var _camera_basis: Basis = $Orbit.global_transform.basis
	
	# Calculate basis and move player based on player input
	var _v_forward := Vector2.from_angle(%Orbit.rotation.y)
	var _v_strafe := Vector2.from_angle(%Orbit.rotation.y + PI / 2.0)
	var _v_forward_normal := Vector3(_v_forward.y, 0, _v_forward.x)
	var _v_strafe_normal := Vector3(_v_strafe.y, 0, _v_strafe.x)
	_target_velocity += _v_forward_normal * -%InputHandler.direction.z * speed * speed_multiplier
	_target_velocity += _v_strafe_normal * %InputHandler.direction.x * speed * speed_multiplier
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	
	# Apply gravity and hover
	var _y_diff: float = $YCast.global_position.y - $YCast.get_collision_point().y
	var _y_target: float = abs($YCast.target_position.y)
	if !$YCast.is_colliding(): # apply gravity even if beyond raycast height
		_y_diff = _y_target
	velocity.y += Dwelt.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Get rotation from input direction and apply it to player mesh
	if %InputHandler.direction.length() > 0:
		_target_y_rotation = %Orbit.rotation.y - _initial_y_rotation
	$RobotMesh.rotation.y = lerp_angle($RobotMesh.rotation.y,
		_target_y_rotation, Utils.crit_plerp(5.0))
	
	if Vector3(velocity * Vector3(1, 0, 1)).length() > 1.0:
		$RobotMesh/Stars.amount_ratio = 1.0
		if !_moving:
			_moving = true
			move_started.emit()
			_target_y_position = 0.1
	else:
		$RobotMesh/Stars.amount_ratio = 0.25
		if _moving:
			_moving = false
			move_stopped.emit()
			_target_y_position = 0.0
	
	$RobotMesh.position.y = lerp($RobotMesh.position.y,
		_target_y_position, Utils.crit_plerp(4.0))
	
	# Send animation parameters to the mesh for animation blending
	$RobotMesh.forward_blend = %InputHandler.direction.z
	$RobotMesh.strafe_blend = %InputHandler.direction.x
