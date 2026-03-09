extends CanvasLayer

func _ready() -> void:
	$DebugBG.queue_free()
	await get_tree().create_timer(0.1).timeout
	$EyesAnim.animate()
