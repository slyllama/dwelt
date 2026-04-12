extends Node

func get_gadget_path(shard_id: String, gadget_id: String) -> String:
	var _path := ("res://shards/" + shard_id + "/gadgets/"
		+ gadget_id + "/" + gadget_id + ".tscn")
	if FileAccess.file_exists(_path):
		return(_path)
	else: return("")
