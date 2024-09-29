@tool
extends "res://lib/map/map.gd"

func _make_ortho_camera() -> void:
	var ortho = Camera3D.new()
	ortho.position.y = 10.0
	ortho.rotation_degrees.x = -90.0
	
	add_child(ortho)
	ortho.set_orthogonal(40.0, 0.0, 100.0)
	ortho.make_current()
	environment.fog_enabled = false
	
	for o: Node in Utilities.get_all_children(self):
		if o is WorldText: o.visible = false
	hud.get_node("Minimap").visible = false
	$Player.queue_free()

func _ready() -> void:
	super()
	# _make_ortho_camera()

func _on_object_interacted() -> void:
	# Reload foliage
	for node: Node in Utilities.get_all_children(self):
		if node is FoliageSpawner:
			node.render()
