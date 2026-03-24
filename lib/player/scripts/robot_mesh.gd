extends Node3D

@export var look_target: Node3D
@export var animation_smoothing := 9.0
@export var turn_rotation_multiplier := 5.0

var forward_blend := 0.0
var strafe_blend := 0.0
var _target_forward_blend := 0.0
var _target_strafe_blend := 0.0
var _ns_count := 0 # no shadows count

@onready var _last_y_rotation := rotation.y

func _ready() -> void:
	for _n: Node in Utils.get_all_children($Armature/Skeleton3D):
		if _n is MeshInstance3D and "Glow" in _n.name:
			_n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			_ns_count += 1
	Utils.pdebug("Removed shadows for " 
		+ str(_ns_count) + " meshes.", "Player/RobotMesh")

var _c := 1.0
func _physics_process(delta: float) -> void:
	if _c > 0: _c -= delta
	else: # defer mesh rotation (otherwise it goes nuts on game start)
		rotation.z = lerp(rotation.z, # rotate the mesh as the camera turns
			(_last_y_rotation - rotation.y) * 3.0,
			Utils.crit_plerp(animation_smoothing))
	
	# Handle forward animation blending
	_target_forward_blend = lerp(_target_forward_blend,
		forward_blend, Utils.crit_plerp(animation_smoothing))
	_target_forward_blend = clamp(_target_forward_blend, -0.5, 1.0)
	$Anim.set("parameters/add_forward/add_amount", _target_forward_blend)
	
	# Handle strafe animation blending
	# (also applied as the player is turned by the camera)
	_target_strafe_blend = lerp(_target_strafe_blend,
		strafe_blend + rotation.z * turn_rotation_multiplier,
		Utils.crit_plerp(animation_smoothing))
	_target_strafe_blend = clamp(_target_strafe_blend, -1.7, 1.7)
	$Anim.set("parameters/add_strafe/add_amount", _target_strafe_blend)
	
	_last_y_rotation = rotation.y
	
	# Attach trails to legs
	$JetTrail_L.global_position = $Armature/Skeleton3D/Foot_SW/Leg_SW.global_position
	$JetTrail_R.global_position = $Armature/Skeleton3D/Foot_SE/Leg_SE.global_position
