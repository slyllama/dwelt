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
signal currency_updated(currency: String)
signal camera_pan_started
signal camera_pan_ended
signal play_flash(position: Vector2)
signal selected_gadget_changed

func update_currency(currency_id: String, amount: int) -> bool:
	var successful := false
	if currency_id in Save.save.currencies:
		var _original_amount: int = Save.save.currencies[currency_id].to_int()
		if _original_amount + amount >= 0:
			Save.save.currencies[currency_id] = str(_original_amount + amount)
			currency_updated.emit(currency_id)
			successful = true
	return(successful)

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

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save.save_file()
