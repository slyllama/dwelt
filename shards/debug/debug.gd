extends "res://lib/shard/shard.gd"

func _ready() -> void:
	super()
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/projectile":
			var _sulphurous_lightning: PackedScene = load(
				"res://shards/acidfields/gadgets/acidic_catalyst/projectiles/sulphurous_lightning/sulphurous_lightning.tscn")
			for _i in 5:
				var _projectile: Projectile = _sulphurous_lightning.instantiate()
				add_child(_projectile)
				_projectile.global_position = Vector3(
					randf_range(Dwelt.player.global_position.x - 2.0, Dwelt.player.global_position.x + 2.0), 0.0,
					randf_range(Dwelt.player.global_position.z - 2.0, Dwelt.player.global_position.z + 2.0))
				await get_tree().create_timer(0.1).timeout)
	
	BOps.gizmo_drag_ended.connect(func() -> void:
		var _g_constructor: Node3D = load(
			"res://bops/gizmo/gizmo_mover_group/gizmo_mover_group.tscn").instantiate()
		$GizmoTest.add_child(_g_constructor))
