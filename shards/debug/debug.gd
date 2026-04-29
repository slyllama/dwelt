extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	BOps.gizmo_drag_ended.connect(func() -> void:
		var _g_constructor: Node3D = load(
			"res://bops/gizmo/gizmo_mover_group/gizmo_mover_group.tscn").instantiate()
		$GizmoTest.add_child(_g_constructor))
