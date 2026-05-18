extends RayCast3D
# Raycast used to hover over gadgets when the controller is in use

var _controller_hovered_gadget: Gadget

func unhover_current_gadget() -> void:
	if _controller_hovered_gadget:
		_controller_hovered_gadget.hover_handler.unhover()
		_controller_hovered_gadget = null

func _input(_event: InputEvent) -> void:
	if !DweltInput.current_device_mode == DweltInput.DeviceModes.CONTROLLER: return
	if Input.is_action_just_pressed("ui_accept"):
		if _controller_hovered_gadget:
			if _controller_hovered_gadget.effect_manager:
				Dwelt.update_selected_gadget(_controller_hovered_gadget)
			else: Dwelt.update_selected_gadget(null)
		else: Dwelt.update_selected_gadget(null)

func _physics_process(_delta: float) -> void:
	# Only activate when using controller to aim
	if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
		unhover_current_gadget()
		return
	if get_collider():
		if get_collider() is Gadget:
			unhover_current_gadget()
			var _gadget: Gadget = get_collider()
			_controller_hovered_gadget = _gadget
			_gadget.hover_handler.hover(true)
		else: unhover_current_gadget()
	else: unhover_current_gadget()
