@tool
class_name EffectCard extends VBoxContainer

# Frame components
var frame_texture := load("res://lib/effect/effect_card/textures/frame.png")
@onready var frame := TextureRect.new()

# Duration bar components
@onready var duration_bar := ProgressBar.new()

func _ready() -> void:
	# Create duration bar
	duration_bar.value = 50.0
	add_child(duration_bar)
	
	# Create frame
	frame.texture = frame_texture
	frame.ignore_texture_size = true
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.custom_minimum_size = Vector2(80.0, 80.0)
	add_child(frame)
