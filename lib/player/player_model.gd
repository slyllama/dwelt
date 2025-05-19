extends Node3D
# PlayerModel
# Controls the player's visual components (animations, particles etc)

@export var smoothing = 5.0 # animation smoothing

var _forward_target = 0.0
var _strafe_target = 0.0

# Should be run every frame
func update_anim_targets(forward: float, strafe: float) -> void:
	var _smooth = Utils.crit_lerp(smoothing) # per-frame animation smoothing
	_forward_target = lerp(_forward_target, forward, _smooth)
	_strafe_target = lerp(_strafe_target, strafe, _smooth)

func _process(_delta: float) -> void:
	$AnimTree.set("parameters/forward_target/add_amount", _forward_target)
	$AnimTree.set("parameters/strafe_target/add_amount", _strafe_target)
