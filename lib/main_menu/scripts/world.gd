extends Node3D

func _on_player_async_loaded() -> void:
	%FadePlayerIn.play("fade_in")
	var player_model: Node3D = $PlayerAsync.add_scene()
	var player_animator: AnimationPlayer = player_model.get_node("AnimationPlayer")
	
	player_animator.animation_finished.connect(func(_anim: String) -> void:
		player_animator.play("idle"))
	player_animator.play("idle")
