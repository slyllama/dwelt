extends Gadget

func _ready() -> void:
	super()
	$Mineral/AnimationPlayer.play("idle")
	
	player_entered_active_area.connect(func() -> void:
		await get_tree().create_timer(0.5).timeout
		if player_in_active_area:
			_on_projectile_timer_timeout()
			$ProjectileTimer.start())
	player_exited_active_area.connect($ProjectileTimer.stop)

func _on_projectile_timer_timeout() -> void:
	var _sulphurous_lightning: PackedScene = load(
		"res://shards/acidfields/gadgets/acidic_catalyst/projectiles/sulphurous_lightning/sulphurous_lightning.tscn")
	for _i in 4:
		var _projectile: Projectile = _sulphurous_lightning.instantiate()
		var _variance := 0.9
		if _i == 0: _variance = 0.0
		_projectile.ready.connect(func() -> void:
			_projectile.global_position = Vector3(
				randf_range(Dwelt.player.global_position.x - _variance, Dwelt.player.global_position.x + _variance),
				Dwelt.player.floor_y_position,
				randf_range(Dwelt.player.global_position.z - _variance, Dwelt.player.global_position.z + _variance)))
		call_deferred("add_child", _projectile)
		await get_tree().create_timer(0.1).timeout
