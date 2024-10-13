@tool
extends Node3D
# Map
# Handles map setting-up functions; should be extended.

const Cutscene = preload("res://lib/cutscene/cutscene_instance.tscn")
const Inspector = preload("res://lib/object/inspector/inspector_instance.tscn")

## This is passed to [code]Global.target_scene_title[/code], which
## [code]MapTitle[/code] will use to render itself.
@export var map_title = "((Map Name))"
@export var map_description = "((Map Description))"
## Moss and ground decals will only be projected onto the children of this node.
@export var decal_candidates: Node
## Child lights of this node will cast shadows when shadows are enabled in the
## game settings.
@export var shadow_lights: Node = null

func _get_all_children(node: Node) -> Array:
	var nodes: Array = []
	if !node: return([])
	for n in node.get_children():
		if n.get_child_count() > 0:
			nodes.append(n)
			nodes.append_array(_get_all_children(n, ))
		else: nodes.append(n)
	return(nodes)

# Enable or disable omni-shadows according to the export variable shadow_lights
func _set_shadows(state) -> void:
	if shadow_lights == null: return
	for n in shadow_lights.get_children():
		if n is OmniLight3D:
			n.shadow_enabled = state

# Pass map configuration data to the Minimap and ping it to update
func configure_map(data: Dictionary):
	Global.minimap_data = Global.MINIMAP_DATA.duplicate() # reset first
	for d in data:
		Global.minimap_data[d] = data[d]
	Global.minimap_refresh.emit()

func _ready() -> void:
	# Set culling mask for objects to be influenced by moss decals
	for node in _get_all_children(decal_candidates):
		if "layers" in node: node.set_layer_mask_value(2, true)
	
	if Engine.is_editor_hint(): return
	Global.target_scene_title = map_title
	Global.target_scene_description = map_description
	
	# Connect settings, apply, and refresh
	SettingsHandler.setting_changed.connect(func(parameter):
		var _value = SettingsHandler.settings[parameter]
		match parameter:
			"fov": CameraData.camera.fov = _value
			"window_mode":
				if _value == "full_screen": get_window().mode = Window.MODE_FULLSCREEN
				elif _value == "maximized": get_window().mode = Window.MODE_MAXIMIZED
				else: get_window().mode = Window.MODE_WINDOWED
			"shadows":
				if _value == "on": _set_shadows(true)
				else: _set_shadows(false)
	)
	SettingsHandler.refresh()
