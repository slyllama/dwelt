class_name HUDButton extends Button

@export var id := "id"
@onready var hover_sound := AudioStreamPlayer.new()

func _init() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	mouse_entered.connect(func():
		modulate = Color(1.1, 1.1, 1.1))
	mouse_exited.connect(func():
		modulate = Color(0.8, 0.8, 0.8))

func _ready() -> void:
	add_child(hover_sound)
	hover_sound.stream = load("res://generic/sounds/tick.ogg")
	mouse_entered.connect(hover_sound.play)
