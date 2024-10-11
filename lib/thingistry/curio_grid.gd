class_name CurioGrid extends VBoxContainer
# CurioGrid
# Renders the grid of curios which plays in the Thingistry

const CurioButton = preload("res://lib/thingistry/curio_button/curio_button.tscn")

@export var width := 5 # grid width, in tiles
@export var height := 4 # grid height, in tils

# Get tiles from Curio.DATA, offset by the given index
func generate(index: int) -> void:
	var _row = HBoxContainer.new()
	_row.custom_minimum_size.y = 110
	# Try get a valid index for each tile in the grid, offset by the given index
	for _h in height:
		for _w in width:
			var _ind = index + _h * width + _w
			# Only instantiate if the index is actually in the dataset
			if _ind < Curio.DATA.size():
				var _curio = CurioButton.instantiate()
				#_curio.get_node("DebugTitle").text = Curio.DATA.keys()[_ind].name
				_curio.curio_id = Curio.DATA.keys()[_ind]
				_row.add_child(_curio)
	add_child(_row)
