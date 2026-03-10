extends Node3D

@export var animation_smoothing := 9.0
@export var turn_rotation_multiplier := 5.0

var forward_blend := 0.0
var strafe_blend := 0.0
var _target_forward_blend := 0.0
var _target_strafe_blend := 0.0

func _physics_process(_delta: float) -> void:
	# Handle forward animation blending
	_target_forward_blend = lerp(_target_forward_blend,
		forward_blend, Utils.crit_plerp(animation_smoothing))
	_target_forward_blend = clamp(_target_forward_blend, -0.5, 1.0)
	$Animations.set("parameters/add_forward/add_amount", _target_forward_blend)
	
	# Handle strafe animation blending
	# (also applied as the player is turned by the camera)
	_target_strafe_blend = lerp(_target_strafe_blend,
		strafe_blend + rotation.z * turn_rotation_multiplier,
		Utils.crit_plerp(animation_smoothing))
	_target_strafe_blend = clamp(_target_strafe_blend, -1.7, 1.7)
	$Animations.set("parameters/add_strafe/add_amount", _target_strafe_blend)
