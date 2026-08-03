extends Control

func update(gadget: Gadget) -> void:
	if gadget:
		%Title.text = gadget.gadget_title
		if gadget.effect_manager:
			if !%EffectBar.effect_manager:
				visible = true
			%EffectBar.effect_manager = gadget.effect_manager
		else: %EffectBar.effect_manager = null
	else:
		%EffectBar.effect_manager = null
		if modulate.a > 0.99:
			visible = false

func _ready() -> void:
	DwGadget.selected_gadget_changed.connect(update)
	visible = false
