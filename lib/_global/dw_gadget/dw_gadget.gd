extends Node
# Global bus variable, functions, and signals related to gadgets and effects

enum ToolMode { NORMAL, SELECT_CLEANSE }

const EFFECTS_PATH := "res://data/effects/"

signal gadget_clicked(gadget: Gadget) # triggers even if the gadget is non-interactive
signal hovered_gadget_changed(gadget: Gadget)
signal tool_mode_changed(new_tool_mode: ToolMode)

var hovered_gadget: Gadget
var tool_mode: ToolMode = ToolMode.NORMAL

func change_tool_mode(new_tool_mode: ToolMode) -> void:
	tool_mode = new_tool_mode
	tool_mode_changed.emit(new_tool_mode)

func get_effect_data(effect_id: String) -> EffectInstance:
	return(load(get_effect_path(effect_id)))

func get_effect_path(effect_id: String) -> String:
	return(EFFECTS_PATH + effect_id + "/" + effect_id + ".tres")

func _ready() -> void:
	hovered_gadget_changed.connect(func(gadget: Gadget) -> void:
		hovered_gadget = gadget)
