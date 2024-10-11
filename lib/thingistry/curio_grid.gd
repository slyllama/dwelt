class_name CurioGrid extends VBoxContainer

class CurioButton extends TextureButton:
	const BASE_TEXTURE = preload("res://lib/thingistry/textures/curio_base.png")
	@export var tile_size := 98.0
	
	func _ready() -> void:
		texture_normal = BASE_TEXTURE
		ignore_texture_size = true
		stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		custom_minimum_size = Vector2(tile_size, tile_size)
		button_down.connect(func():
			pass)

var total_tiles = 19
@export var width := 5 # grid width, in tiles

func generate_row(row_width: int) -> void:
	var _row = HBoxContainer.new()
	for _i in row_width:
		var _curio = CurioButton.new()
		_row.add_child(_curio)
	add_child(_row)

func _ready() -> void:
	while total_tiles >= width:
		generate_row(width)
		total_tiles -= width
	generate_row(total_tiles)
