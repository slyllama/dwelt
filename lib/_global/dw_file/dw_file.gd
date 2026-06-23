extends Node

func exists(path: String) -> bool:
	return(FileAccess.file_exists(path))

func get_json(path: String) -> Dictionary:
	var _f := FileAccess.open(path, FileAccess.READ)
	var _f_json: Dictionary = JSON.parse_string(_f.get_as_text())
	_f.close()
	return(_f_json)

func store_json(path: String, data: Dictionary) -> void:
	var _f := FileAccess.open(path, FileAccess.WRITE)
	_f.store_string(JSON.stringify(data, "\t"))
	_f.close()
