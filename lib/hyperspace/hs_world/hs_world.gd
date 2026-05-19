extends Node3D

@export var intensity := 1.0
@export var smoothing := 1.0
@export var tick_speed := 0.2

var offset_target := 0.0
var _c := 0.0

func _physics_process(delta: float) -> void:
	_c += delta
	if _c > tick_speed:
		offset_target = randf() - 0.5
		_c = 0
	%HSProjector.rotation.z += delta * 0.1
	if %HSProjector.rotation.z >= 360.0:
		%HSProjector.rotation.z = 0.0
	%Camera.v_offset = lerp(%Camera.v_offset,
		offset_target * intensity, delta * smoothing)
