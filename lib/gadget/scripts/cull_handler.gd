class_name CullHandler extends Node
# The cull handler ensures that meshes are properly configured for fading out
# once they reach a certain distance from the camera

@export var cull_model: Node3D
@export var cull_distance := 5.0:
	set(_cull_distance):
		cull_distance = _cull_distance
		apply_cull_amounts()
@export var cull_fade_length := 0.3:
	set(_cull_fade_length):
		cull_fade_length = _cull_fade_length
		apply_cull_amounts()

func get_mesh_instances() -> Array[MeshInstance3D]:
	var mesh_instances: Array[MeshInstance3D] = []
	if cull_model:
		for _n: Node in Utils.get_all_children(cull_model):
				if _n is MeshInstance3D:
					mesh_instances.append(_n)
	return(mesh_instances)

func apply_cull_amounts() -> void:
	for _n: MeshInstance3D in get_mesh_instances():
		_n.visibility_range_end = cull_distance
		_n.visibility_range_end_margin = cull_fade_length

func _ready() -> void:
	for _n: MeshInstance3D in get_mesh_instances():
		_n.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	apply_cull_amounts()
