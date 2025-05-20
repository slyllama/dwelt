class_name ProjectileEvent extends Node3D

var projectile_count = 0
var is_destroyed = false

func play(data: Dictionary) -> void:
	if !"type" in data: # fail if important information is missing
		print("[ProjectileEvent] Event data is missing type.")
		queue_free()
	match data.type:
		"test":
			var _amount = 12
			for _i in _amount:
				var _p = Projectile.new()
				_p.position.z = 2.0
				_p.rotation.y = 2 * PI / _amount * _i
				_p.lifetime = 5.0
				_p.destroyed.connect(func(): projectile_count -= 1)
				add_child(_p)
				
				projectile_count += 1

func _ready() -> void:
	position.y = 0.25

func _process(_delta: float) -> void:
	if projectile_count == 0 and !is_destroyed:
		is_destroyed = true
		queue_free()
