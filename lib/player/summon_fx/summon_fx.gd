extends Node3D
var mat: ShaderMaterial

func _set_params_1(value: float) -> void:
	var _v = ease(value, -4)
	mat.set_shader_parameter("alpha", _v)
	var _s = 1.0 + _v
	$Plane.mesh.size = Vector2(_s, _s)

func _set_params_2(value: float) -> void:
	var _v = ease(value, 0.4)
	mat.set_shader_parameter("alpha", 1 - _v)
	mat.set_shader_parameter("distortion_level", 0.01 + _v * 0.09)
	var _s = 2.0 + _v * 5
	$Plane.mesh.size = Vector2(_s, _s)

func _ready() -> void:
	mat = $Plane.get_active_material(0).duplicate()
	$Plane.set_surface_override_material(0, mat)
	$Motes.global_position = global_position
	$Motes.emitting = true
	
	$PreEntry.play()
	var fx_tween_1 = create_tween()
	fx_tween_1.tween_method(_set_params_1, 0.0, 1.0, 0.5)
	await get_tree().create_timer(1).timeout
	$Motes.speed_scale = 3.0
	$Motes.emitting = false
	
	var fx_tween_2 = create_tween()
	fx_tween_2.tween_method(_set_params_2, 0.0, 1.0, 0.7)
	
	Global.shake_camera.emit()
	$Entry.play()

func _process(delta: float) -> void:
	$Plane.rotation_degrees.y += 40 * delta

func _on_entry_finished() -> void:
	$Motes.queue_free()
	queue_free()
