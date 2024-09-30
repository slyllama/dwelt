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

# Change this before invoking the loader - it will load whatever scene is here
var target_scene = "res://maps/lyllian/lyllian.tscn"
func change_map(map_name: String) -> void:
	target_scene = "res://maps/" + map_name + "/" + map_name + ".tscn"
	get_tree().change_scene_to_file("res://lib/map/loader/loader.tscn")

signal interact_pressed
signal move_player(pos: Vector3) # when called, will move the player
signal objects_loaded # ObjectHandler has gathered all of its objects into object_data
signal pylon_start_activated(id)
signal pylon_end_activated(id) # activated a destination pylon
signal proximity_entered
signal proximity_left
signal shake_camera()

var active_pylon = ACTIVE_PYLON.duplicate()
var foliage_count = 0
var loaded_once = false
var object_data = []
var player_position = Vector3.ZERO
var proximal_object = PROXIMAL_OBJECT.duplicate()
var retina_scale = 1.0

# Checks to see if the mouse is in a UI elements
func mouse_in_ui() -> bool:
	if mouse_in_map or mouse_in_ui_container:
		return(true)
	else: return(false)

var mouse_in_map = false
var mouse_in_ui_container = false
