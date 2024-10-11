class_name CurioGrid extends VBoxContainer

const CurioButton = preload("res://lib/thingistry/curio_button/curio_button.tscn")

var total_tiles = 19
@export var width := 5 # grid width, in tiles

func generate_row(row_width: int) -> void:
	var _row = HBoxContainer.new()
	_row.custom_minimum_size.y = 110
	for _i in row_width:
		var _curio = CurioButton.instantiate()
		_row.add_child(_curio)
	add_child(_row)

func _ready() -> void:
	while total_tiles >= width:
		generate_row(width)
		total_tiles -= width
	generate_row(total_tiles)
