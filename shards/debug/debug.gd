extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	BOps.gizmo_mover_drag_ended.connect(func() -> void:
		var _g_constructor: Node3D = load(
			"res://bops/gizmo/gizmo_mover/gizmo_mover_constructor.tscn").instantiate()
		$GizmoTest.add_child(_g_constructor))
	
	Dwelt.discord_update_details("((Uhhhhh))")
