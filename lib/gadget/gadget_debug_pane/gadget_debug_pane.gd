@tool
extends UIPane

func update(gadget: Gadget) -> void:
	if gadget: %GadgetTitle.text = "Selected gadget: " + str(gadget.gadget_id)
	else: %GadgetTitle.text = "Selected gadget: none"
	
	if gadget:
		if gadget.effect_manager:
			%EffectBar.effect_manager = gadget.effect_manager
		else: %EffectBar.effect_manager = null
	else: %EffectBar.effect_manager = null

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	
	DwGadget.selected_gadget_changed.connect(update)
	update(DwGadget.selected_gadget)
	
	await get_tree().process_frame
	position.x = 10.0
