extends TextureRect

@export var frame_duration := 0.05

const FRAME_PATH = "res://lib/hud/eye_anim/frames/"
@onready var FRAMES := [
	load(FRAME_PATH + "0.png"),
	load(FRAME_PATH + "1.png"),
	load(FRAME_PATH + "2.png"),
	load(FRAME_PATH + "3.png"),
	load(FRAME_PATH + "4.png"),
	load(FRAME_PATH + "5.png"),
	load(FRAME_PATH + "6.png"),
	load(FRAME_PATH + "7.png"),
	load(FRAME_PATH + "8.png"),
	load(FRAME_PATH + "9.png"),
	load(FRAME_PATH + "10.png"),
	load(FRAME_PATH + "11.png"),
	load(FRAME_PATH + "12.png"),
	load(FRAME_PATH + "13.png"),
	load(FRAME_PATH + "14.png"),
	load(FRAME_PATH + "15.png") ]

var running := false

func animate() -> void:
	if running: return
	running = true
	visible = true
	
	for _f: Resource in FRAMES:
		await get_tree().create_timer(frame_duration).timeout
		texture = _f
	
	texture = null
	queue_free()

func _init() -> void:
	z_index = 100 # play on top of everything else

func _ready() -> void:
	visible = true
