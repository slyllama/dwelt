class_name CullHandler extends Node
# The cull handler ensures that meshes are properly configured for fading out
# once they reach a certain distance from the camera.

@export var cull_model: Node3D:
	set(_cull_model):
		cull_model = _cull_model
		for _n: MeshInstance3D in get_mesh_instances():
			_n.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
		apply_cull_amounts()
@export var cull_distance := 5.0:
	set(_cull_distance):
		cull_distance = _cull_distance
		actual_cull_distance = cull_distance
		apply_cull_amounts()
@export var cull_fade_length := 0.3:
	set(_cull_fade_length):
		cull_fade_length = _cull_fade_length
		apply_cull_amounts()

var actual_cull_distance := 0.0

func get_mesh_instances() -> Array[MeshInstance3D]:
	var mesh_instances: Array[MeshInstance3D] = []
	if cull_model:
		for _n: Node in Utils.get_all_children(cull_model):
			if _n is MeshInstance3D:
				mesh_instances.append(_n)
	return(mesh_instances)

func apply_cull_amounts() -> void:
	for _n: MeshInstance3D in get_mesh_instances():
		_n.visibility_range_end = actual_cull_distance
		_n.visibility_range_end_margin = cull_fade_length

func _ready() -> void:
	Settings.setting_applied.connect(func(setting: String, value: String) -> void:
		if setting == "draw_distance":
			if value == "medium": actual_cull_distance = cull_distance
			elif value == "low" : actual_cull_distance = cull_distance * 0.5
			elif value == "high" : actual_cull_distance = cull_distance * 1.5
			apply_cull_amounts())
