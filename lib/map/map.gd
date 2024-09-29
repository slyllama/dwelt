@tool
extends Node3D
# Map
# Handles map setting-up functions; should be extended.

const HUD = preload("res://lib/ui/hud/hud.tscn")
const ObjectHandler = preload("res://lib/object/object_handler/object_handler.tscn")

@export var environment: Environment
## Moss and ground decals will only be projected onto the children of this node.
@export var decal_candidates: Node
@export var start_muted = false

var sky: WorldEnvironment
var hud

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Toggle full-screen
	if Input.is_action_just_pressed("debug_key"):
		if get_window().mode != Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		else: get_window().mode = Window.MODE_WINDOWED

func _fade_sound_in() -> void:
	# Fade in the entire audio server after a delay, preventing any first-frame blips
	await get_tree().create_timer(0.1).timeout
	var audio_in = create_tween()
	audio_in.tween_method(func(vol):
		AudioServer.set_bus_volume_db(0, linear_to_db(vol)), 0.0, 1.0, 1.0)

func _init() -> void:
	if !Engine.is_editor_hint():
		hud = HUD.instantiate()
		add_child(hud)

func _ready() -> void:
	AudioServer.set_bus_volume_db(0, -80)
	if !start_muted:
		_fade_sound_in()

	if sky != null: sky.queue_free()
	sky = WorldEnvironment.new()
	add_child(sky)
	# Duplicate the environment to avoid editing the original resource
	if environment != null:
		var e = environment.duplicate(true)
		sky.environment = e
	
	if Engine.is_editor_hint(): return
	# Set up the ObjectHandler and environment
	var object_handler = ObjectHandler.instantiate()
	add_child(object_handler)
	
	# Set culling mask for objects to be influenced by moss decals
	for node in Utilities.get_all_children(decal_candidates):
		if "layers" in node: node.set_layer_mask_value(2, true)
