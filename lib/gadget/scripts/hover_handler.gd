class_name HoverHandler extends Node
# The HoverHandler is responsibly for correctly highlighting gadgets when the
# player hovers over them with the mouse

@export var hover_model: Node3D:
	set(_hover_model):
		hover_model = _hover_model

var materials: Array[StandardMaterial3D]

func hover() -> void:
	for _m: StandardMaterial3D in materials:
		_m.albedo_color = Color(1.1, 1.1, 1.1)

func unhover() -> void:
	for _m: StandardMaterial3D in materials:
		_m.albedo_color = Color(1, 1, 1)

func get_mesh_instances() -> Array[MeshInstance3D]:
	var mesh_instances: Array[MeshInstance3D] = []
	if hover_model:
		for _n: Node in Utils.get_all_children(hover_model):
			if _n is MeshInstance3D:
				mesh_instances.append(_n)
	return(mesh_instances)

func _ready() -> void:
	# Append all unique materials to the array
	for _n: MeshInstance3D in get_mesh_instances():
			if !_n.get_active_material(0) in materials:
				materials.append(_n.get_active_material(0))
	
	# Connect UI input events
	if get_parent() is StaticBody3D:
		var _parent: StaticBody3D = get_parent()
		_parent.mouse_entered.connect(hover)
		_parent.mouse_exited.connect(unhover)
