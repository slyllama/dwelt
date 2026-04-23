@icon("res://generic/icons/GadgetManager.svg")
class_name GadgetManager extends Node3D

@export var shard_id := "shard"
@export var shard_title := "Shard"

func load_gadgets_from_save() -> void:
	var shard_data: Dictionary = Save.save.shard_data[shard_id]
	# Add a gadget list to this shard's data in the save, if it doesn't exist
	if !"gadgets" in shard_data:
		shard_data["gadgets"] = []
	for id: String in shard_data.gadgets:
		if GadgetData.get_gadget_path(id) == "":
			Utils.pdebug("Couldn't load gadget '" + id
				+ "' because its path did not resolve.", "GadgetManager")
			continue
		
		# Get the list of all gadgets in the shard with the same ID
		var gadget_list: Array = shard_data.gadgets[id]
		# Load the first gadget in the array
		var _async_loader := Async3DLoader.new()
		var _path: String = GadgetData.get_gadget_path(id)
		
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
				_scene_position = Utils.str_to_vec3(gadget_data.position)
			if "rotation" in gadget_data:
				_scene_rotation = Utils.str_to_vec3(gadget_data.rotation)
			if "scale" in gadget_data:
				_scene_scale = Utils.str_to_vec3(gadget_data.scale)
			var _scene: Gadget = _async_loader.add_scene(
				_scene_position, _scene_rotation, _scene_scale)
			
			# TODO: apply saved effects here
			_scene.ready.connect(func() -> void:
				if _scene.effect_manager and "effect_data" in gadget_data:
					_scene.effect_manager.apply_effects_from_dict(gadget_data.effect_data))
			
		# Gracefully free the AsyncLoader as it is no longer needed
		_async_loader.close()

func write_gadgets_to_save() -> void:
	var _gadgets := {} # will be populated before being applied to the save
	for _n: Node in get_children():
		if _n is Gadget:
			var _data := {
				"position": Utils.vec3_to_str(_n.position),
				"rotation": Utils.vec3_to_str(_n.rotation),
				"scale": Utils.vec3_to_str(_n.scale) }
			
			if _n.effect_manager:
				_data["effect_data"] = _n.effect_manager.get_effects_as_dict()
			
			if !_n.gadget_id in _gadgets: _gadgets[_n.gadget_id] = []
			_gadgets[_n.gadget_id].append(_data)
	Save.save.shard_data[shard_id].gadgets = _gadgets.duplicate()

func _ready() -> void:
	Dwelt.gadget_manager = self
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/reloadgadgets":
			for _n: Node in get_children(): _n.queue_free()
			Dwelt.gadgets_reloaded.emit()
			load_gadgets_from_save()
		elif string == "/savegadgets":
			write_gadgets_to_save()
			Save.save_file())
	
	Dwelt.discord_update_details(shard_title)
	
	await get_tree().process_frame
	load_gadgets_from_save()
