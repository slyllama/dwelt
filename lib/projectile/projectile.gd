class_name Projectile extends Node3D

const ProjectileMaterial = preload("res://generic/materials/mat_projectile.tres")

@onready var area = Area3D.new()

@export var active = false
@export var radius = 0.25
@export var lifetime = 1.0
@export var graze_score = 10

@export var forward_speed = 1.0
@export var forward_acceleration = 5.0
@export var sideways_speed = 1.0
@export var sideways_acceleration = 0.0

func destroy() -> void:
	if !active: return
	Reporter.projectile_count -= 1 # track projectile count
	
	active = false
	var _scale_tween = create_tween()
	_scale_tween.tween_property(area, "scale", Vector3(0.01, 0.01, 0.01), 0.07)
	_scale_tween.tween_callback(queue_free)

func _ready() -> void:
	Reporter.projectile_count += 1
	
	area.body_entered.connect(func(body):
		if body == Reporter.player: # connection for hitting player
			Reporter.do_shake_camera.emit()
		destroy())
	add_child(area)
	area.position.x = 2.0
	
	# Set up collision shape
	var collision_shape = CylinderShape3D.new()
	collision_shape.radius = radius
	var collision = CollisionShape3D.new()
	collision.shape = collision_shape
	area.add_child(collision)
	
	# Add cosmetic sphere
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = sphere_mesh.radius * 2.0
	sphere_mesh.radial_segments = 16
	sphere_mesh.rings = 8
	
	var sphere = MeshInstance3D.new()
	sphere.mesh = sphere_mesh
	sphere.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	sphere.set_surface_override_material(0, ProjectileMaterial)
	area.add_child(sphere)
	
	# Add graze
	var graze = ProjectileGraze.new()
	graze.has_grazed.connect(func():
		print("[Projectile] Grazed."))
	area.add_child(graze)
	
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.timeout.connect(destroy)
	add_child(timer)
	timer.start()
	
	var _scale_tween = create_tween()
	_scale_tween.tween_property(area, "scale", Vector3(1.0, 1.0, 1.0), 0.12)
	_scale_tween.tween_callback(func(): active = true)

@onready var _forward_speed = forward_speed
@onready var _sideways_speed = sideways_speed

func _process(delta: float) -> void:
	
	area.position.x += delta * _forward_speed
	area.position.z += delta * _sideways_speed
