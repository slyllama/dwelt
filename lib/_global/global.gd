extends Node
# Global
# General global data

const PROXIMAL_OBJECT = { 
	"id": "none",
	"title": "(Title)",
	"description": "(Description)",
	"interact_string": "(Interact)",
	"can_interact": false
}
const ACTIVE_PYLON = { "id": "none", "position": Vector3.ZERO }
const MINIMAP_DATA = {
	"image_path": "null",
	"magnitude": 20,
	"image_scale": 1,
	"image_rotation": 0,
	"bg_color": Color(0.1, 0.1, 0.1),
	"offset_x": 0,
	"offset_y": 0,
	"object_scale": 1.25 # I don't know why this works but it does
}

# Change this before invoking the loader - it will load whatever scene is here
# Allows for serialised (.scn) scenes too
var target_scene = "res://lib/launcher/launcher.tscn"
func change_map(map_name: String) -> void:
	var _ext = ".tscn"
	var _path = "res://maps/" + map_name + "/" + map_name
	if ResourceLoader.exists(_path + ".tscn"):
		target_scene = _path + ".tscn"
	elif ResourceLoader.exists(_path + ".scn"):
		target_scene = _path + ".scn"
	get_tree().change_scene_to_file("res://lib/map/loader/loader.tscn")

signal click_sound
signal hover_sound

signal hud_toggle_hidden(state)

signal interact_pressed
signal minimap_refresh # force Minimap to call update() again
signal move_player(pos: Vector3) # when called, will move the player
signal objects_loaded # ObjectHandler has gathered all of its objects into object_data
signal pylon_start_activated(id)
signal pylon_end_activated(id) # activated a destination pylon
signal proximity_entered
signal proximity_left
signal shake_camera()

var active_pylon = ACTIVE_PYLON.duplicate()

var foliage_count = 0
var in_cutscene = false
var minimap_data = MINIMAP_DATA.duplicate()
var object_data = []
var player_position = Vector3.ZERO
var player_can_move = true
var popup_open = false # mainly used for orbit checks in CameraHandler
var proximal_object = PROXIMAL_OBJECT.duplicate()
var retina_scale = 1.0

# Checks to see if the mouse is in a UI elements
func mouse_in_ui() -> bool:
	if mouse_in_map or mouse_in_ui_container:
		return(true)
	else: return(false)

var mouse_in_map = false
var mouse_in_ui_container = false
