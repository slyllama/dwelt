@tool
extends "res://lib/map/map.gd"

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	$Ambience.play()
	await get_tree().create_timer(2.0).timeout
	$Music.play()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	$EnemyRotator.rotation_degrees.y += delta * 15.0

func _on_object_interacted() -> void:
	for node: Node in Utilities.get_all_children(self):
		if node is FoliageSpawner:
			node.render()
