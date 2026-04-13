extends Node

const GRAVITY := -9.8

# References
var camera: Camera3D
var gadget_manager: GadgetManager
var player_effect_manager: EffectManager
var ui_pane_manager: UIPaneManager

var gadgets_close_to_player: Array[Gadget] = []
var pan_cooldown := false
var selected_gadget: Gadget

# Global signal bus
signal clicked_collision_object(object: CollisionObject3D)
signal click_sound_requested
signal currency_updated(currency: String)
signal camera_pan_started
signal camera_pan_ended
signal claim_requested # emitted by the HUD when the player requests to claim a gadget
signal gadgets_close_to_player_changed
signal gadgets_reloaded # used to clear effects panes, etc
signal play_flash(position: Vector2)
signal selected_gadget_changed
signal shake_camera

# Return the gadget closest to the player
func get_closest_gadget() -> Variant:
	if gadgets_close_to_player.size() > 0:
		return(gadgets_close_to_player[-1])
	else: return(null)

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
	if selected_gadget:
		$Click.play()
	selected_gadget_changed.emit(selected_gadget)
	
	# If the player is in interacting range of the gadget, recorded it as the
	# closest gadget to the player
	if selected_gadget in gadgets_close_to_player:
		gadgets_close_to_player.erase(selected_gadget)
		gadgets_close_to_player.push_back(selected_gadget)
		gadgets_close_to_player_changed.emit()

func _init() -> void:
	AudioServer.set_bus_volume_linear(0, 0.0)

func _ready() -> void:
	click_sound_requested.connect($Click.play)
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/pause": get_tree().paused = true
		elif string == "/unpause": get_tree().paused = false
		
		elif string == "/geteffectsdict":
			if selected_gadget:
				if selected_gadget.effect_manager:
					Utils.pdebug(str(selected_gadget.effect_manager.get_effects_as_dict())))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Dwelt.gadget_manager.write_gadgets_to_save()
		Save.save_file()
