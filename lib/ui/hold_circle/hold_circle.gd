class_name HoldCircle extends Node2D
# HoldCircle
# Displays a progress bar in the form of a hollow circle. Holding the interact
# key will fill it (and releasing it will clear it); a signal will be emitted
# if it is completed.

@onready var current_shape: Polygon2D = get_node("CircleBool")
signal completed # user has finished interacting

@export var time = 1.0
var root_node = Node2D.new()
var is_spinning = false
var rotator: Tween

# Fill in a quadrant by manipulating a clipping triangle
func _set_right_poly(_angle: float) -> void:
	current_shape.polygon[2] = Vector2(
		cos(_angle - PI / 2) * 150.0, sin(_angle - PI / 2) * 150.0)

# Use 'finished' to indicate that the bar has gone the whole way around
func stop(finished = false) -> void:
	if !is_spinning: return
	is_spinning = false
	
	$Blur.visible = false
	$Hold.stop()
	if rotator != null:
		rotator.stop()
		root_node.queue_free()
	
	if finished:
		completed.emit()
		$Anims.play("complete")

func spin() -> void:
	if is_spinning: return # don't start twice!
	is_spinning = true
	
	$Blur.visible = true
	$Hold.play()
	root_node = Node2D.new()
	add_child(root_node)
	
	for _i in 4: # spin a wedge for each 90 degree quadrant
		if is_spinning:
			rotator = create_tween()
			var _q: Polygon2D = $CircleBool.duplicate()
			_q.rotation_degrees = 90.0 * _i
			_q.visible = true
			root_node.add_child(_q)
			current_shape = _q
			_set_right_poly(0.0)
			rotator.tween_method(_set_right_poly,
				0.0, PI / 2, time / 4.0)
			await rotator.finished
	stop(true)

func _ready() -> void:
	$EditorCircle.visible = false # circle for placing in editor only

func _input(_event: InputEvent) -> void:
	if !visible: return # use visibility to set active/inactive
	if Input.is_action_just_pressed("interact"):
		spin()
	if Input.is_action_just_released("interact"):
		stop(false)

func _on_visibility_changed() -> void:
	if !visible: # suspend current activity if made invisible
		stop()
