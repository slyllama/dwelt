@tool
extends UIPane

func _ready() -> void:
	super()
	
	DwGadget.selected_gadget_changed.connect(func(_gadget: Gadget) -> void:
		if _gadget: %GadgetTitle.text = "Selected gadget: " + str(_gadget.gadget_id)
		else: %GadgetTitle.text = "Selected gadget: none")
