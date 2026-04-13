extends Node

@export var effect_manager: EffectManager

var claim_target: Gadget

func initiate_claim() -> void:
	if Dwelt.get_closest_gadget():
		claim_target = Dwelt.get_closest_gadget()
		effect_manager.add_effect(load("res://effects/claiming.tres"))

func cancel_claim() -> void:
	effect_manager.cancel_effect("claiming")
	claim_target = null

func _ready() -> void:
	if !effect_manager:
		Utils.pdebug("No attached effect manager.", "Player/ClaimHandler")
		queue_free()
		return
	
	effect_manager.effect_finished.connect(func(id: String) -> void:
		if id == "claiming":
			claim_target.effect_manager.cancel_effect("enemy_owned")
			claim_target = null
			# Force the "claim" button to update
			Dwelt.gadgets_close_to_player_changed.emit())
	
	Dwelt.claim_requested.connect(initiate_claim)
	#Dwelt.gadgets_close_to_player_changed.connect(func() -> void:
		#if "claiming" in effect_manager.active_effects:
			#if !claim_target in Dwelt.gadgets_close_to_player:
				#cancel_claim())
