extends Node
# Global bus variable, functions, and signals related to gadgets and effects

const EFFECTS_PATH := "res://data/effects/"

signal gadget_clicked(gadget: Gadget) # triggers even if the gadget is non-interactive
signal hovered_gadget_changed(gadget: Gadget)

var hovered_gadget: Gadget

func get_effect_data(effect_id: String) -> EffectInstance:
	return(load(get_effect_path(effect_id)))

func get_effect_path(effect_id: String) -> String:
	return(EFFECTS_PATH + effect_id + "/" + effect_id + ".tres")

func _ready() -> void:
	hovered_gadget_changed.connect(func(gadget: Gadget) -> void:
		hovered_gadget = gadget)
