class_name Projectile extends Area3D

@export var cast_time := 3.0
@export var strips_resilience := true

@onready var cast_timer := Timer.new()

func is_player_colliding() -> bool:
	var _player_colliding := false
	var _colliders := get_overlapping_bodies()
	for _collider: PhysicsBody3D in _colliders:
		if _collider is DweltPlayer:
			_player_colliding = true
			break
	return(_player_colliding)

func _ready() -> void:
	cast_timer.wait_time = cast_time
	cast_timer.one_shot = true
	cast_timer.timeout.connect(func() -> void:
		# Fire
		if is_player_colliding() and strips_resilience:
			Dwelt.player_effect_manager.decrement_effect_qty("resilience")
		queue_free())
	
	add_child(cast_timer)
	cast_timer.start()
