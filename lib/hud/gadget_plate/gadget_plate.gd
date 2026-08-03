extends Control

func update(gadget: Gadget) -> void:
	if gadget:
		%Title.text = gadget.gadget_title
		%Description.text = gadget.gadget_description
		if gadget.effect_manager:
			if !%EffectBar.effect_manager:
				await get_tree().process_frame
				visible = true
			%EffectBar.effect_manager = gadget.effect_manager
		else: %EffectBar.effect_manager = null
	else:
		%EffectBar.effect_manager = null
		visible = false

func _ready() -> void:
	DwGadget.gadget_hovered.connect(update)
	visible = false
