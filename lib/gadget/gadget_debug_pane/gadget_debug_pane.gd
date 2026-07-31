@tool
extends UIPane

func update(gadget: Gadget) -> void:
	if gadget: %GadgetTitle.text = "Selected gadget: " + str(gadget.gadget_id)
	else: %GadgetTitle.text = "Selected gadget: none"

func _ready() -> void:
	super()
	
	DwGadget.selected_gadget_changed.connect(update)
	update(DwGadget.selected_gadget)
	
	await get_tree().process_frame
	position.x = 10.0
