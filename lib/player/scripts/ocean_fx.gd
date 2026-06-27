extends RayCast3D

func toggle_ocean_fx(state := true) -> void:
	$Particles.emitting = state

func _process(_delta: float) -> void:
	if get_collider():
		$Particles.global_position = get_collision_point()

func _on_tick_timeout() -> void:
	if get_collider():
		toggle_ocean_fx()
	else: toggle_ocean_fx(false)
