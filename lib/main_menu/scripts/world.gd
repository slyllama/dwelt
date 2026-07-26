extends Node3D

var player_model: Node3D

func _on_player_async_loaded() -> void:
	%FadePlayerIn.play("fade_in")
	player_model = $PlayerAsync.add_scene()
	await player_model.ready
	
	# Copy this async node's position and rotation to the resulting mesh
	player_model.global_position = $PlayerAsync.global_position
	player_model.global_rotation = $PlayerAsync.global_rotation
	$PlayerAsync.close()
	
	# Clear shadows
	var _ns_count := 0
	for _n: Node in DwUtils.get_all_children(player_model.get_node("RobotMesh/Armature/Skeleton3D")):
		if _n is MeshInstance3D and DwGlobal.NO_SHADOW_EXPRESSION in _n.name:
			_n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			_ns_count += 1
	DwUtils.pdebug("Removed shadows for " 
		+ str(_ns_count) + " meshes.", "MainMenu/World")
