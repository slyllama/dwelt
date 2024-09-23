extends Node3D
# TestProjectile

@export var delay = 1.0 ## Time before firing.
@export var emit_effects = false ## If true, will emit screen distortion and light.
@export var start_speed = 8.0
@export var end_speed = 3.5
@export var speed_smoothing = 0.1

var speed = 0.0
var fired = false

func _distort_prop(parameter: String, value: float) -> void:
	$DistortionMesh.get_active_material(0).set_shader_parameter(parameter, value)

func fire() -> void:
	var fade_in = create_tween()
	fade_in.tween_property($Arrow, "modulate:a", 1.0, 0.2)
	$StartTimer.start()
	await $StartTimer.timeout
	
	fired = true
	speed = start_speed
	$BulletContainer.top_level = true
	fade_in = create_tween()
	fade_in.tween_property($Arrow, "modulate:a", 0.0, 0.4)
	
	if emit_effects:
		$DistortionMesh/Glow.light_energy = 5.0
		var glow_fade = create_tween()
		glow_fade.tween_property($DistortionMesh/Glow, "light_energy", 0.0, 0.5)
		
		Global.shake_camera.emit()
		$DistortionMesh/Stars.emitting = true
	
	await get_tree().create_timer(0.1).timeout
	var distort_tween = create_tween()
	distort_tween.tween_method(func(val):
		if emit_effects:
			_distort_prop("circle_position", val)
			_distort_prop("alpha", ease(1.0 - val, -0.2))
		var ease_scale = ease(1.0 - val, -0.1)
		$BulletContainer/Bullet/Mesh.scale = Vector3(ease_scale, ease_scale, ease_scale)
	, 0.0, 1.0, 1.0)

func _ready() -> void:
	$StartTimer.wait_time = delay
	$Arrow.modulate.a = 0.0
	
	if emit_effects:
		$DistortionMesh.visible = true
		_distort_prop("circle_position", 0.0)
		_distort_prop("alpha", 0.0)

func _physics_process(delta: float) -> void:
	if fired:
		speed = lerp(speed, end_speed, speed_smoothing)
	$BulletContainer/Bullet.position += Vector3.FORWARD * delta * speed

func _on_life_ended() -> void:
	queue_free()

func _on_bullet_hit_player() -> void:
	queue_free()
