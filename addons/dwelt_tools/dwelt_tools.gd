@tool
extends EditorPlugin

func make_save_default() -> void:
	if FileAccess.file_exists(Save.SAVE_PATH):
		DirAccess.copy_absolute(Save.SAVE_PATH, "res://default.json")

func index_gadget_paths() -> void:
	var _path_list: Dictionary[String, String] = {}
	for _shard_path in GadgetData.SHARD_PATHS:
		var _path := _shard_path + "gadgets/"
		if DirAccess.dir_exists_absolute(_path):
			var _dir_list := DirAccess.get_directories_at(_path)
			for _name in _dir_list:
				var _gadget_path := _path + _name + "/" + _name + ".tscn"
				if FileAccess.file_exists(_gadget_path):
					_path_list[_name] = _gadget_path
	
	# Get global gadgets
	for _global_name in DirAccess.get_directories_at(GadgetData.GLOBAL_SHARD_PATH):
		var _global_gadget_path := (GadgetData.GLOBAL_SHARD_PATH
			+ _global_name + "/" + _global_name + ".tscn")
		if FileAccess.file_exists(_global_gadget_path):
			_path_list[_global_name] = _global_gadget_path
	
	var _index_file := FileAccess.open(GadgetData.INDEX_FILE_PATH, FileAccess.WRITE)
	_index_file.store_var(_path_list)
	_index_file.close()

func _enter_tree() -> void:
	add_tool_menu_item("Make Save Default", make_save_default)
	add_tool_menu_item("Index Gadget Paths", index_gadget_paths)

func _exit_tree() -> void:
	remove_tool_menu_item("Make Save Default")
	remove_tool_menu_item("Index Gadget Paths")
