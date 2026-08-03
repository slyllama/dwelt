extends PanelContainer
# Sidebar

# Quick trick to hide the sidebar endpiece if the gadget plate is not visible
func _on_gadget_plate_visibility_changed() -> void:
	%Endpiece.visible = %GadgetPlate.visible
