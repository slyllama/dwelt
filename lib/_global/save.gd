extends Node
# Save manager/bus

const SAVE_PATH := "user://save.json"
const DEFAULT_SAVE := {
	"currencies": {
		"kinetic": "0",
		"elemental": "0",
		"verdant": "0",
		"arcane": "0"
	},
	"shard_data": {}
}

@onready var save := DEFAULT_SAVE.duplicate(true)

func save_exists() -> bool:
	return(FileAccess.file_exists(SAVE_PATH))

func new_file_from_default() -> void:
	Utils.pdebug("Creating new save from default level.", "Save")
	DirAccess.copy_absolute("res://default.json", Save.SAVE_PATH)

func load_file() -> void:
	if save_exists():
		var _f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if !_f.get_as_text():
			_f.close()
			return
		var _f_json: Dictionary = JSON.parse_string(_f.get_as_text())
		# Update values in `save` rather than replacing the whole thing -
		# ensures that new values are appropriately added to the save
		for parameter: String in _f_json:
			# Only values already in `DEFAULT_SETTINGS` get updated
			if parameter in DEFAULT_SAVE:
				save[parameter] = _f_json[parameter]
		_f.close()

func save_file() -> void:
	if Dwelt.gadget_manager: # pull latest gadget data, if the manager is in the scene
		Dwelt.gadget_manager.write_gadgets_to_save()
	var _f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	_f.store_string(JSON.stringify(save, "\t"))
	_f.close()

func _ready() -> void:
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/save": save_file())
	process_mode = Node.PROCESS_MODE_ALWAYS
