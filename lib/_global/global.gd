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

const ACTIVE_PYLON = {
	"id": "none",
	"position": Vector3.ZERO
}

signal move_player(pos: Vector3) # when called, will move the player
signal pylon_start_activated(id)
signal pylon_end_activated(id) # activated a destination pylon
signal proximity_entered
signal proximity_left

var active_pylon = ACTIVE_PYLON.duplicate()
var foliage_count = 0
var player_position = Vector3.ZERO
var proximal_object = PROXIMAL_OBJECT.duplicate()
