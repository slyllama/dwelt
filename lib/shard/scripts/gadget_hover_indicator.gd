extends MeshInstance3D

func move_to_hovered_gadget() -> bool:
	if DwGadget.hovered_gadget:
		global_position = (DwGadget.hovered_gadget.global_position
			+ Vector3(0, 0.25, 0))
		return(true)
	else: return(false)

func _ready() -> void:
	DwGadget.tool_mode_changed.connect(func(_new_tool_mode: DwGadget.ToolMode) -> void:
		if DwGadget.is_in_selection_mode():
			if move_to_hovered_gadget(): visible = true
			else: visible = false
		else: visible = false)
	
	DwGadget.hovered_gadget_changed.connect(func(_gadget: Gadget) -> void:
		if DwGadget.is_in_selection_mode():
			if move_to_hovered_gadget(): visible = true
			else: visible = false
		else: visible = false)
