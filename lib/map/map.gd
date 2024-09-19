@tool
extends Node3D
# Map
# Handles map setting-up functions; should be extended.

const DefaultFloor = preload("res://lib/map/default_floor/default_floor.tscn")
const HUD = preload("res://lib/ui/hud/hud.tscn")
const ObjectHandler = preload("res://lib/object/object_handler.tscn")

@export var environment: Environment
## Moss and ground decals will only be projected onto nodes listed here.
@export var ground_decal_meshes: Array[Node]
@export var default_floor = false

var floor_mesh

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	# 'Regenerate' the player by moving it to the last activated pylon
	if Input.is_action_just_pressed("debug_key"):
		if Global.active_pylon.id != "none":
			%Player.position = (
				Global.active_pylon.position + Vector3(-0.45, 0, 0))

func _ready() -> void:
	# The floor is always added because it contains the fallback ground mesh; but it can be hidden
	if floor_mesh != null: floor_mesh.queue_free()
	floor_mesh = DefaultFloor.instantiate()
	add_child(floor_mesh)
	if !default_floor:
		floor_mesh.get_node("Mesh").visible = false
	
	if Engine.is_editor_hint(): return
	# Set up the HUD, ObjectHandler, and environment
	var hud = HUD.instantiate()
	add_child(hud)
	var object_handler = ObjectHandler.instantiate()
	add_child(object_handler)
	var sky = WorldEnvironment.new()
	add_child(sky)
	if environment != null: sky.environment = environment
	
	# Retina screen scaling
	if DisplayServer.screen_get_size().x > 2000:
		get_window().size *= 2.0
		get_window().content_scale_factor = 2.0
	
	# Set culling mask for objects to be influenced by moss decals
	for base_node in ground_decal_meshes:
		for node in Utilities.get_all_children(base_node):
			if "layers" in node:
				node.set_layer_mask_value(2, true)
