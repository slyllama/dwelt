extends Node
# Global bus variable, functions, and signals related to gadgets and effects

const EFFECTS_PATH := "res://data/effects/"

signal gadget_clicked(gadget: Gadget) # triggers even if the gadget is non-interactive
signal selected_gadget_changed(gadget: Gadget)
signal selected_gadget_updated # emitted by the selected gadget when an effect is added/changed/removed

var selected_gadget: Gadget

func get_effect_data(effect_id: String) -> EffectInstance:
	return(load(EFFECTS_PATH + effect_id + "/" + effect_id + ".tres"))

func update_selected_gadget(gadget: Gadget) -> void:
	selected_gadget = gadget
	selected_gadget_changed.emit(selected_gadget)
