extends Node3D

func _ready() -> void:
	await get_tree().process_frame
	for _n: Node in get_children():
		_n.reparent(get_parent())
