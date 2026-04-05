extends Node

const GRAVITY := -9.8

# References
var camera: Camera3D
var player_effect_manager: EffectManager
var ui_pane_manager: UIPaneManager

var selected_gadget: Gadget

# Global signal bus
signal clicked_collision_object(object: CollisionObject3D)
signal click_sound_requested
signal camera_pan_started
signal camera_pan_ended
signal selected_gadget_changed

func update_selected_gadget(gadget: Gadget) -> void:
	selected_gadget = gadget
	selected_gadget_changed.emit(selected_gadget)

func _init() -> void:
	AudioServer.set_bus_volume_linear(0, 0.0)

func _ready() -> void:
	click_sound_requested.connect($Click.play)
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/pause": get_tree().paused = true
		elif string == "/unpause": get_tree().paused = false)
