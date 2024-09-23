extends CharacterBody3D
# TestEnemy
# Takes damage and shoots projectiles! Just for fun

const Projectile = preload("res://lib/test_enemy/test_projectile/test_projectile.tscn")

@export var health: float = 100
var health_bar: Node

func _ready() -> void:
	health_bar = $HealthBar # need to get a reference before it is reparented to screen-space
	$WorldText.track_node($HealthBar)
	_on_test_tick()

func _process(_delta: float) -> void:
	health_bar.value = health

var c = 14
var offset = false

func _on_test_tick() -> void:
	for x in c:
		var p = Projectile.instantiate()
		if x == 0: p.emit_effects = true
		p.rotation_degrees.y = x * 360.0 / c
		p.delay += x * 0.03
		if offset: p.rotation_degrees.y += 360.0 / c / 2
		add_child(p)
		
		p.fire()
	
	offset = !offset
