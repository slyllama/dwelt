extends Node3D
# TuningCrystal
# A tuning crystal allows its user to synchronise with a ley-line to which it
# is connected. In joining with it the user can travel this ley-line, bridging
# large areas with incredible speed.

const TestEnemy = preload("res://lib/test_enemy/test_enemy.tscn")
signal tick
var rng = RandomNumberGenerator.new()
var playing = false

@export var id = "tuning_crystal"

func start() -> void:
	$Pylon/Object.can_interact = false
	$BG.visible = true
	Global.proximity_left.emit()
	playing = true
	
	await get_tree().create_timer(0.4).timeout
	var enemy = TestEnemy.instantiate()
	enemy.position = Vector3(0, 0.5, 3.0)
	add_child(enemy)
	$Music.play()

func _ready() -> void:
	$Pylon/Object.id = id

var ticker: float = -1.0

func _process(_delta):
	var time = ($Music.get_playback_position()
		+ AudioServer.get_time_since_last_mix())
	time -= AudioServer.get_output_latency()
	if time - ticker >= 1.0:
		ticker += 1.0
		Global.tick.emit()
	$BG/Debug.text = "[center]Mix time: " + str(int(ticker)) + "[/center]"

func _on_crystal_interact() -> void:
	start()
