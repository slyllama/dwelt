@tool
extends "res://lib/map/map.gd"

@onready var test_bot_z_pos = $TestBot.position.z

func _distort_prop(parameter: String, value: float) -> void:
	$DistortionMesh.get_active_material(0).set_shader_parameter(parameter, value)

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	$TestBot.position.z += delta * 0.82
	if $TestBot.position.z > test_bot_z_pos + 2.7:
		$TestBot.position.z = test_bot_z_pos

func _on_object_interacted() -> void:
	# Reload foliage
	for node: Node in Utilities.get_all_children(self):
		if node is FoliageSpawner:
			node.render()

func _ripple() -> void:
	$DistortionMesh.visible = true
	$DistortionMesh/Stars.restart()
	$DistortionMesh/Stars.emitting = true
	Global.shake_camera.emit()
	
	var distort_tween = create_tween()
	distort_tween.tween_method(func(val):
		_distort_prop("circle_position", val)
		_distort_prop("alpha", ease(1.0 - val, -0.2))
	, 0.0, 1.0, 1.0)
	distort_tween.tween_callback(func():
		$DistortionMesh.visible = false)
