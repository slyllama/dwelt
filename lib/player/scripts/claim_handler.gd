extends Node

@export var effect_manager: EffectManager

func initiate_claim() -> void:
	if Dwelt.selected_gadget:
		Dwelt.claim_target = Dwelt.selected_gadget
		effect_manager.add_effect(load("res://effects/claiming.tres"))

func cancel_claim() -> void:
	effect_manager.cancel_effect("claiming")
	Dwelt.claim_target = null

func _ready() -> void:
	if !effect_manager:
		Utils.pdebug("No attached effect manager.", "Player/ClaimHandler")
		queue_free()
		return
	
	effect_manager.effect_finished.connect(func(id: String) -> void:
		if id == "claiming":
			Dwelt.claim_target.effect_manager.cancel_effect("enemy_owned")
			Dwelt.claim_target = null
			# Force the "claim" button to update
			Dwelt.gadgets_close_to_player_changed.emit())
	
	Dwelt.claim_requested.connect(initiate_claim)
