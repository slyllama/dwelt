class_name MakeGhostMesh extends Node
# MakeGhostMesh - turns parent into a ghost

var ghost_material: ShaderMaterial = load("res://bops/bops_ghost/materials/ghost.tres")

func _ready() -> void:
	if !get_parent() is Node3D:
		queue_free()
		return
	
	for _n: Node in Utils.get_all_children(get_parent()):
		if _n is MeshInstance3D:
			_n.cast_shadow = false
			if _n.get_active_material(0) is ShaderMaterial:
				if _n.get_active_material(0).get_shader_parameter("albedo_texture"):
					var _mask: Texture2D = _n.get_active_material(0).get_shader_parameter("albedo_texture")
					ghost_material.set_shader_parameter("mask", _mask)
				_n.set_surface_override_material(0, ghost_material)
