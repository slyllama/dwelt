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

signal damage_taken
signal died
signal move_player(pos: Vector3) # when called, will move the player
signal objects_loaded # ObjectHandler has gathered all of its objects into object_data
signal pylon_start_activated(id)
signal pylon_end_activated(id) # activated a destination pylon
signal proximity_entered
signal proximity_left
signal shake_camera()
signal tick

var active_pylon = ACTIVE_PYLON.duplicate()
var foliage_count = 0
var object_data = []
var mouse_in_map = false
var player_position = Vector3.ZERO
var proximal_object = PROXIMAL_OBJECT.duplicate()
