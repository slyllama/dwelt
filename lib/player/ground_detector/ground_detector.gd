extends RayCast3D

var _is_colliding = false
signal ground_collided

func _physics_process(_delta: float) -> void:
	if is_colliding():
		if !_is_colliding:
			_is_colliding = true
			ground_collided.emit()
	else:
		if _is_colliding:
			_is_colliding = false
