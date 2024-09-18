extends "res://lib/map/map.gd"

func _ready() -> void:
	super()

func _on_object_interacted() -> void:
	for node: Node in self.get_children():
		if node is FoliageSpawner:
			node.render()
