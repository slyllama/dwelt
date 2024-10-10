extends Node2D

@onready var current_shape: Polygon2D = get_node("CircleBool")
signal completed

var root_node = Node2D.new()
var is_spinning = false
var rotator: Tween

func _set_right_poly(_angle: float) -> void:
	current_shape.polygon[2] = Vector2(
		cos(_angle - PI / 2) * 150.0, sin(_angle - PI / 2) * 150.0)

func _stop(finished = false) -> void:
	rotator.stop()
	is_spinning = false
	root_node.queue_free()
	
	if finished: completed.emit()

func _spin(time: float) -> void:
	is_spinning = true
	root_node = Node2D.new()
	add_child(root_node)
	
	for _i in 4:
		if is_spinning:
			rotator = create_tween()
			var _q: Polygon2D = $CircleBool.duplicate()
			_q.rotation_degrees = 90.0 * _i
			_q.visible = true
			root_node.add_child(_q)
			current_shape = _q
			_set_right_poly(0.0)
			rotator.tween_method(_set_right_poly, 0.0, PI / 2, time / 4.0)
			await rotator.finished
	_stop(true)

func _ready() -> void:
	$EditorCircle.queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		_spin(2.0)
	if Input.is_action_just_released("interact"):
		if is_spinning:
			_stop(false)
