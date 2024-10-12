@tool
class_name CurioGrid extends VBoxContainer
# CurioGrid
# Renders the grid of curios which plays in the Thingistry

const CurioButtonScene = preload("res://lib/thingistry/curio_button/curio_button.tscn")

@export var width := 3 # grid width, in tiles
@export var height := 5 # grid height, in tils

# we get the first child so we can check its id
var button_nodes: Array[CurioButton]

# Get tiles from Curio.DATA, offset by the given index
func generate(index: int) -> void:
	# Try get a valid index for each tile in the grid, offset by the given index
	for _h in height:
		var _row = HBoxContainer.new()
		_row.custom_minimum_size.y = 92
		for _w in width:
			var _ind = index + _h * width + _w
			var _curio = CurioButtonScene.instantiate()
			
			# Only instantiate if the index is actually in the dataset
			if _ind < Curio.DATA.size():
				_curio.curio_id = Curio.DATA.keys()[_ind]
				button_nodes.append(_curio)
			else:
				_curio.curio_id = "none" # makes a useless button
			_row.add_child(_curio)
		add_child(_row)

var _dummy_rows = []

func _ready() -> void:
	# Editor-only filling in of buttons, for testing purposes
	if Engine.is_editor_hint():
		for _row in _dummy_rows:
			_row.queue_free() # clean up editor stuff
		
		for _h in height:
			var _row = HBoxContainer.new()
			_row.custom_minimum_size.y = 92
			for _w in width:
				var _ind = _h * width + _w
				var _curio = CurioButtonScene.instantiate()
				_row.add_child(_curio)
			add_child(_row)
			_dummy_rows.append(_row)
