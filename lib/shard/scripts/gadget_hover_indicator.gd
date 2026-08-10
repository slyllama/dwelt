extends MeshInstance3D

func _ready() -> void:
	DwGadget.gadget_hovered.connect(func(gadget: Gadget) -> void:
		if gadget:
			visible = true
			global_position = gadget.global_position + Vector3(0, 0.25, 0)
		else: visible = false)
