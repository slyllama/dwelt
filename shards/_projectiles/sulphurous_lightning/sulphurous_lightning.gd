extends Projectile

func _on_ready() -> void:
	var _r := randf()
	$Decal.rotation.y = PI * _r
	$LightningFork.region_rect.position.x = 64.0 * floor(_r * 8)
	if _r > 0.5:
		$LightningFork.flip_h = true
