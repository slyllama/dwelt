class_name GadgetManager extends Node3D

func load_gadgets_from_save() -> void:
	for _data: Dictionary in Save.save.gadgets:
		if !"id" in _data: continue
		if _data.id in GadgetData.DATA:
			var _async_loader := Async3DLoader.new()
			var _path: String = GadgetData.DATA[_data.id].path
			_async_loader.path = _path
			if "position" in _data:
				_async_loader.position = Utils.str_to_vec3(_data.position)
			add_child(_async_loader)

func _ready() -> void:
	if "gadgets" in Save.save:
		load_gadgets_from_save()
