extends Node3D

@onready var rng = RandomNumberGenerator.new()

var clockwise = true

func _ready() -> void:
	get_window().mode = Window.MODE_FULLSCREEN

func _process(delta: float) -> void:
	$Camera.position = lerp(
		$Camera.position, $Player.position,
		Utils.crit_lerp(delta, 20.0))

func _on_test_timer_timeout() -> void:
	clockwise = !clockwise
	#var _rotation_offset = rng.randf_range(0.0, 10.0)
	for _i in 15:
		var _p = Projectile.new()
		_p.position.y = 0.5
		_p.rotation_degrees.y = _i * 360 / 15.0
		_p.radius = 0.17
		_p.lifetime = 3.0
		
		if clockwise: _p.z_acceleration = 0.03
		else: _p.z_acceleration = -0.03
		
		add_child(_p)
