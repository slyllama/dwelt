@tool
class_name EffectCard extends VBoxContainer

# Frame components
var frame_texture := load("res://lib/effect/effect_card/textures/frame.png")
@onready var frame := TextureRect.new()

func _ready() -> void:
	# Create frame
	frame.texture = frame_texture
	frame.ignore_texture_size = true
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.custom_minimum_size = Vector2(80.0, 80.0)
	add_child(frame)
