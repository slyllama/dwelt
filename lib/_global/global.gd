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

# Use this function when taking damage to ensure that the rules are followed
# Makes tracking damage and death emissions easier
func lose_health(amount: float):
	if health - amount > 0:
		health -= amount
	else:
		health = 0
		died.emit()
	damage_taken.emit()

const MAX_HEALTH: float = 100

signal damage_taken
signal died
signal move_player(pos: Vector3) # when called, will move the player
signal pylon_start_activated(id)
signal pylon_end_activated(id) # activated a destination pylon
signal proximity_entered
signal proximity_left
signal shake_camera()
signal tick

var active_pylon = ACTIVE_PYLON.duplicate()
var foliage_count = 0
var health: float = MAX_HEALTH
var player_position = Vector3.ZERO
var proximal_object = PROXIMAL_OBJECT.duplicate()
