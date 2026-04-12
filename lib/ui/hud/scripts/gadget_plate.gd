extends Panel
# Displays information about the currently selected gadget

func update(gadget: Gadget = Dwelt.selected_gadget) -> void:
	if gadget:
		visible = true
		$GadgetEffects.effect_manager = gadget.effect_manager
		if gadget.effect_manager:
			if "enemy_owned" in gadget.effect_manager.active_effects:
				$GadgetAvatarPlate.effect_particles_playing = true
			else: $GadgetAvatarPlate.effect_particles_playing = false
	else: 
		visible = false
		$GadgetEffects.effect_manager = null

func _ready() -> void:
	await get_tree().process_frame
	# Mainly to update gadget ownership if claimed by the player
	Dwelt.player_effect_manager.effect_finished.connect(update.unbind(1))
	Dwelt.selected_gadget_changed.connect(update)
	Dwelt.gadgets_reloaded.connect(update.bind(null))
	
	visible = false
