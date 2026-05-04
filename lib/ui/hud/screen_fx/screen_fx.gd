extends CanvasLayer

func _ready() -> void:
	await get_tree().process_frame
	Dwelt.player_effect_manager.effect_decremented.connect(func(id: String) -> void:
		if id == "resilience":
			$FXAnims.stop()
			$FXAnims.play("flash_damage"))
