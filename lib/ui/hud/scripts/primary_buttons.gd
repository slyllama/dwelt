extends Control
# Handle logic for primary buttons - mainly whether they are enabled or not
# (e.g., only claim if the gadget you are closest to is in a position to be claimed)

func _ready() -> void:
	Dwelt.gadgets_close_to_player_changed.connect(func() -> void:
		if Dwelt.get_closest_gadget():
			var _closest_gadget: Gadget = Dwelt.get_closest_gadget()
			if _closest_gadget.get_effect("enemy_owned"):
				$Claim.disabled = false
			else: $Claim.disabled = true
		else: $Claim.disabled = true)

# Cannot be pressed unless it is actually valid
func _on_claim_pressed() -> void:
	Utils.pdebug("Claim requested...", "HUD/PrimaryButtons")
	Dwelt.claim_requested.emit()
