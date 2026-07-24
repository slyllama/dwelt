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
