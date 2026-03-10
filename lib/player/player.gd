extends CharacterBody3D

@export_category("Physics")
@export var speed := 3.4
@export var speed_multiplier := 1.0 # used for lethargy etc
@export var friction := 16.0
@export var gravity_damping := 10.0

var _target_velocity := Vector3.ZERO
var _target_y_rotation := 0.0
var _target_z_rotation := 0.0 # tilt when rotating camera

func _physics_process(_delta: float) -> void:
	$Trail_L.global_position = $RobotMesh/Armature/Skeleton3D/Foot_NE/Leg_NE.global_position
	$Trail_R.global_position = $RobotMesh/Armature/Skeleton3D/Foot_NW/Leg_NW.global_position
	
	_target_velocity = Vector3.ZERO
	var _camera_basis: Basis = %Orbit.global_transform.basis
	
	var _v_forward := Vector2.from_angle(%Orbit.rotation.y)
	var _v_strafe := Vector2.from_angle(%Orbit.rotation.y + PI / 2.0)
	var _v_forward_normal := Vector3(_v_forward.y, 0, _v_forward.x)
	var _v_strafe_normal := Vector3(_v_strafe.y, 0, _v_strafe.x)
	_target_velocity += _v_forward_normal * -%InputHandler.direction.z * speed * speed_multiplier
	_target_velocity += _v_strafe_normal * %InputHandler.direction.x * speed * speed_multiplier
	velocity = lerp(velocity, _target_velocity, Utils.crit_plerp(friction))
	
	# Apply gravity and hover
	var _y_diff: float = %YCast.global_position.y - %YCast.get_collision_point().y
	var _y_target: float = abs(%YCast.target_position.y)
	if !%YCast.is_colliding(): # apply gravity even if beyond raycast height
		_y_diff = _y_target
	velocity.y += Dwelt.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Calculate rotations which are only influenced when the player is moving
	if velocity.length_squared() > 0:
		_target_y_rotation = %Orbit.rotation.y + PI
		_target_z_rotation = %InputHandler.camera_rotate_input * 0.1
	else: _target_z_rotation = 0.0
	
	# Apply rotations
	%RobotMesh.rotation.y = lerp_angle(
		%RobotMesh.rotation.y, _target_y_rotation, Utils.crit_plerp(6.0))
	%RobotMesh.rotation.z = lerp_angle(
		%RobotMesh.rotation.z, _target_z_rotation, Utils.crit_plerp(6.0))
	
	# Send animation parameters to the mesh for animation blending
	$RobotMesh.forward_blend = %InputHandler.direction.z
	$RobotMesh.strafe_blend = %InputHandler.direction.x
