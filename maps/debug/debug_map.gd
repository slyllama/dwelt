extends Node3D

@onready var rng = RandomNumberGenerator.new()

const AMOUNT = 12
const AMOUNT_X = 5

#func _process(_delta: float) -> void:
	#$Camera.position = lerp(
		#$Camera.position, $Player.position,
		#Utils.crit_lerp(20.0))

# Reduce stutter by adding a projectile to the map
func _preload_projectile() -> void:
	var _p = Projectile.new()
	_p.position.y = -1.0
	add_child(_p)
	for _i in 3: await get_tree().process_frame
	_p.queue_free()

func _ready() -> void:
	_preload_projectile()

func _on_gadget_interacted() -> void:
	var _e = ProjectileEvent.new()
	_e.position.y = -1.0
	add_child(_e)
	
	_e.play({ "type": "test" })
	
	#for z in AMOUNT:
		#for x in AMOUNT_X:
			#var _p = Projectile.new()
			#_p.position.x = x * 0.7 - AMOUNT_X * 0.7 / 2.0
			#_p.position.z = z * 0.7 - AMOUNT * 0.5 + 1.0
			#_p.lifetime = 7.0
			#_p.radius = 0.21
			#_p.rotation.y = -PI * 1/2
			##_p.rotation.y = rng.randf_range(PI + 0.8, 2 * PI - 0.8)
			##_p.forward_speed = randf_range(0.6, 1.0)
			#add_child(_p)
