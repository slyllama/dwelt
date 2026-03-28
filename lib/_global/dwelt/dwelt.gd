extends Node

const GRAVITY := -9.8

# References
var camera: Camera3D
var ui_pane_manager: UIPaneManager

# Global signal bus
signal clicked_collision_object(object: CollisionObject3D)
signal click_sound_requested

func _init() -> void:
	AudioServer.set_bus_volume_linear(0, 0.0)

func _ready() -> void:
	click_sound_requested.connect($Click.play)
