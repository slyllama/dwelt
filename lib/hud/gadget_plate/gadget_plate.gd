extends Control

func update(gadget: Gadget) -> void:
	if gadget:
		%Title.text = gadget.name
		if gadget.effect_manager:
			%EffectBar.effect_manager = gadget.effect_manager
		else: %EffectBar.effect_manager = null
		visible = true
	else:
		%EffectBar.effect_manager = null
		visible = false

func _ready() -> void:
	DwGadget.selected_gadget_changed.connect(update)
	visible = false
