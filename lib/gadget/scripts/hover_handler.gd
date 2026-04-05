class_name HoverHandler extends Node
# The HoverHandler is responsibly for correctly highlighting gadgets when the
# player hovers over them with the mouse

# WARNING: these must be set before adding the child
@export var hover_model: Node3D
@export var hover_shape: StaticBody3D

func hover() -> void:
	for _n: MeshInstance3D in get_mesh_instances():
		_n.set_instance_shader_parameter("highlight", true)

func unhover() -> void:
	for _n: MeshInstance3D in get_mesh_instances():
		_n.set_instance_shader_parameter("highlight", false)

func get_mesh_instances() -> Array[MeshInstance3D]:
	var mesh_instances: Array[MeshInstance3D] = []
	if hover_model:
		for _n: Node in Utils.get_all_children(hover_model):
			if _n is MeshInstance3D:
				mesh_instances.append(_n)
	return(mesh_instances)

func _ready() -> void:
	# Connect UI input events
	if hover_shape:
		hover_shape.mouse_entered.connect(hover)
		hover_shape.mouse_exited.connect(unhover)
