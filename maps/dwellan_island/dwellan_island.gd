@tool
extends "res://lib/map/map.gd"

func _ready() -> void:
	super()

func _on_object_interacted() -> void:
	for node: Node in Utilities.get_all_children(self):
		if node is FoliageSpawner:
			node.render()
