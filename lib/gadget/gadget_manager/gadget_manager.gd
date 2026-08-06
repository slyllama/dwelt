@icon("res://generic/icons/GadgetManager.svg")
class_name GadgetManager extends Node3D

@onready var shard: Shard = get_parent()
@onready var data_file_name := shard.shard_id + "_" + "gadgets.json"
@onready var data_file_path := DwGlobal.SAVE_PATH + data_file_name

func get_gadget_path(gadget_id: String) -> String:
	return("res://gadgets/" + gadget_id + "/" + gadget_id + ".tscn")

func load_gadgets() -> void:
	# No gadget data for this shard
	if !FileAccess.file_exists(data_file_path): return
	for _n in get_children(): _n.queue_free() # clear of old gadgets
	var _file := FileAccess.open(data_file_path, FileAccess.READ)
	var _gadget_data: Dictionary = JSON.parse_string(_file.get_as_text())
	_file.close()
	
	for id: String in _gadget_data:
		var gadget_list: Array = _gadget_data[id]
		var _async_loader := Async3DLoader.new()
		var _path: String = get_gadget_path(id)
			
		_async_loader.path = _path
		add_child(_async_loader)
		await _async_loader.loaded
		
		# Create a node for each dictionary instance in the gadget data array
		for gadget_data: Dictionary in gadget_list:
			var _scene_position := Vector3.ZERO
			var _scene_rotation := Vector3.ZERO
			var _scene_scale := Vector3(1.0, 1.0, 1.0)
			
			# Apply transformations if they have been saved to file
			if "position" in gadget_data:
				_scene_position = DwUtils.str_to_vec3(gadget_data.position)
			if "rotation" in gadget_data:
				_scene_rotation = DwUtils.str_to_vec3(gadget_data.rotation)
			if "scale" in gadget_data:
				_scene_scale = DwUtils.str_to_vec3(gadget_data.scale)
			var _scene: Gadget = _async_loader.add_scene(
				_scene_position, _scene_rotation, _scene_scale)
			
			_scene.ready.connect(func() -> void:
				if _scene.effect_manager and "effect_data" in gadget_data:
					_scene.effect_manager.apply_effects_from_dict(gadget_data.effect_data))
			
		# Gracefully free the AsyncLoader as it is no longer needed
		_async_loader.close()

func save_gadgets() -> void:
	var _gadget_data := {}
	for _n: Node in get_children(): # populate
		if _n is Gadget:
			var _data := {
				"position": DwUtils.vec3_to_str(_n.position),
				"rotation": DwUtils.vec3_to_str(_n.rotation),
				"scale": DwUtils.vec3_to_str(_n.scale) }
			if _n.effect_manager:
				_data["effect_data"] = _n.effect_manager.get_effects_as_dict()
			if !_n.gadget_id in _gadget_data: _gadget_data[_n.gadget_id] = []
			_gadget_data[_n.gadget_id].append(_data)
	
	var _file := FileAccess.open(data_file_path, FileAccess.WRITE)
	_file.store_string(JSON.stringify(_gadget_data, "    "))
	_file.close()

func _init() -> void:
	DwUtils.debug_sent.connect(func(_cmd: String) -> void:
		if _cmd == "/savegadgets": save_gadgets()
		elif _cmd == "/loadgadgets": load_gadgets())
