extends Node

const SHARD_PATHS: Array[String] = [
	"res://shards/acidfields/",
	"res://shards/debug/"
]

const GLOBAL_SHARD_PATH := "res://shards/_gadgets/"
const INDEX_FILE_PATH := "res://gadget_index.dat"

var path_list: Dictionary[String, String] = {}

func get_gadget_path(gadget_id: String) -> String:
	if gadget_id in path_list:
		return(path_list[gadget_id])
	else: return("")

func _ready() -> void:
	if FileAccess.file_exists(INDEX_FILE_PATH):
		var _index_file := FileAccess.open(INDEX_FILE_PATH, FileAccess.READ)
		path_list = _index_file.get_var()
		_index_file.close()
	else:
		Utils.pdebug("Warning: no gadget index found at "
			+ INDEX_FILE_PATH + ".", "Gadget_data")
	
	Utils.pdebug("Indexed paths for "
		+ str(path_list.size()) + " gadgets.", "GadgetData")
