extends Sprite3D

const Y_OFFSET := 1.5

func _ready() -> void:
	$GenericAoe.position.y = -Y_OFFSET
	Dwelt.selected_gadget_changed.connect(func(gadget: Gadget) -> void:
		if !gadget: visible = false
		else:
			visible = true
			global_position = gadget.global_position + Vector3(0, Y_OFFSET, 0)
			$GenericAoe.mesh.radius = Dwelt.selected_gadget.claim_radius)
