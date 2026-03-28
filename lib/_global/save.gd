extends Node
# Save manager/bus

const SAVE_PATH := "user://save.json"
const DEFAULT_SAVE := {
	"gadgets": [
		{
			"path": "res://lib/gadget/test_gadget.tscn",
			"position": "0.00, 0.50, 2.50"
		}
	]
}

@onready var save := DEFAULT_SAVE.duplicate()

func load_file() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var _f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		var _f_json: Dictionary = JSON.parse_string(_f.get_as_text())
		# Update values in `save` rather than replacing the whole thing -
		# ensures that new values are appropriately added to the save
		for parameter: String in _f_json:
			# Only values already in `DEFAULT_SETTINGS` get updated
			if parameter in DEFAULT_SAVE:
				save[parameter] = _f_json[parameter]
		_f.close()

func save_file() -> void:
	var _f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	_f.store_string(JSON.stringify(save, "\t"))
	_f.close()

func _ready() -> void:
	load_file()
	save_file()
