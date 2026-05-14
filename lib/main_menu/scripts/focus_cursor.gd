extends Sprite2D

var target_position := Vector2.ZERO

func _process(_delta: float) -> void:
	global_position = lerp(global_position, target_position, Utils.crit_lerp(45.0))
