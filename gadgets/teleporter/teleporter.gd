extends Gadget

func _on_ready() -> void:
	$Teleporter/AnimationPlayer.speed_scale = 0.5
	$Teleporter/AnimationPlayer.play("spin")
	
	$Teleporter/AnimationPlayer.set_blend_time("spin", "activate", 0.35)
	$Teleporter/AnimationPlayer.set_blend_time("activate", "spin", 0.35)

func _on_activate_area_body_entered(body: Node3D) -> void:
	if body is DweltPlayer:
		$Teleporter/AnimationPlayer.play("activate")

func _on_activate_area_body_exited(body: Node3D) -> void:
	if body is DweltPlayer:
		$Teleporter/AnimationPlayer.play("spin")
