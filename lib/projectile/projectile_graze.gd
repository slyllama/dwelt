class_name ProjectileGraze extends Area3D

@export var radius = 0.3
var is_grazed = false

signal has_grazed

func grazed() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.25
	timer.one_shot = true
	timer.timeout.connect(func():
		# TODO: check that the player hasn't been hit since graze
		has_grazed.emit())
	add_child(timer)
	timer.start()

func _ready() -> void:
	# Set up graze shape
	body_entered.connect(func(body):
		if body == Reporter.player: grazed())
	
	var graze_shape = SphereShape3D.new()
	graze_shape.radius = radius
	
	var graze_collision = CollisionShape3D.new()
	add_child(graze_collision)
	graze_collision.shape = graze_shape
