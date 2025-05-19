extends Node3D

@onready var rng = RandomNumberGenerator.new()

const AMOUNT = 12
var clockwise = true

func _process(_delta: float) -> void:
	$Camera.position = lerp(
		$Camera.position, $Player.position,
		Utils.crit_lerp(20.0))

func _on_test_timer_timeout() -> void:
	clockwise = !clockwise
	#var _rotation_offset = rng.randf_range(0.0, 10.0)
	for _i in 15:
		var _p = Projectile.new()
		_p.position.y = 0.5
		_p.rotation_degrees.y = _i * 360 / 15.0
		_p.radius = 0.17
		_p.lifetime = 3.0
		
		add_child(_p)

func _on_gadget_interacted() -> void:
	for z in AMOUNT:
		for x in AMOUNT:
			var _p = Projectile.new()
			_p.position.x = x * 0.7 - AMOUNT * 0.5
			_p.position.z = z * 1.2 - AMOUNT * 0.75
			_p.lifetime = 7.0
			_p.rotation.y = rng.randf_range(PI + 0.8, 2 * PI - 0.8)
			_p.forward_speed = randf_range(0.8, 1.4)
			add_child(_p)
