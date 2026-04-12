extends Node3D

@export var target: Node3D

var target_orb: GPUParticles3D

func _ready() -> void:
	target_orb = $Orb.duplicate()
	target_orb.top_level = true
	add_child(target_orb)

func _physics_process(_delta: float) -> void:
	if target and target_orb:
		target_orb.global_position = target.global_position
		$Orb.global_position = global_position
		$Beam.look_at(target_orb.global_position)
		$Beam.rotation_degrees.x += 90.0
		$Beam.global_position = (target_orb.global_position + $Orb.global_position) / 2.0
		
		var _length: float = $Orb.global_position.distance_to(target_orb.global_position)
		$Beam.scale.y = _length
		
		#$Beam.global_position = target_orb.global_position
		#$Beam.look_at($Orb.global_position)
		#$Beam.rotation_degrees.x += 90.0
