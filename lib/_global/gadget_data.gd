extends Node

const SHARD_PATHS: Array[String] = [
	"res://shards/acidfields/",
	"res://shards/debug/"
]

var path_list: Dictionary[String, String] = {}

func get_gadget_path(gadget_id: String) -> String:
	if gadget_id in path_list:
		return(path_list[gadget_id])
	else: return("")

func _ready() -> void:
	for _shard_path in SHARD_PATHS:
		var _path := _shard_path + "gadgets/"
		if DirAccess.dir_exists_absolute(_path):
			var _dir_list := DirAccess.get_directories_at(_path)
			for _name in _dir_list:
				var _gadget_path := _path + _name + "/" + _name + ".tscn"
				if FileAccess.file_exists(_gadget_path):
					path_list[_name] = _gadget_path
	Utils.pdebug("Indexed paths for "
		+ str(path_list.size()) + " gadgets.", "GadgetData")
