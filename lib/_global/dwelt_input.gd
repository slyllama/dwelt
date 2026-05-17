extends Node
# Handle Dwelt's custom input signals and methods i.e., updating display and
# input if the player switches from keyboard to controller or vice versa

enum DeviceModes { CONTROLLER, KEYBOARD }

var current_device_mode := DeviceModes.KEYBOARD

# Current effect being inspected via the controller's `inspect_effects` button
signal focused_effect_changed(effect_card: EffectCard)
signal current_device_changed

# Update the input mode depending on whether a controller or keyboard is
# being used
func update_device_display() -> void:
	if DweltInput.current_device_mode == DweltInput.DeviceModes.CONTROLLER:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif DweltInput.current_device_mode == DweltInput.DeviceModes.KEYBOARD:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	current_device_changed.connect(update_device_display)
	
	for _i in 3: await get_tree().process_frame
	if Input.get_connected_joypads().size() > 0:
		current_device_mode = DeviceModes.CONTROLLER
		current_device_changed.emit()

func _input(event: InputEvent) -> void:
	if current_device_mode == DeviceModes.KEYBOARD:
		if (event is InputEventJoypadButton
			or event is InputEventJoypadMotion):
			current_device_mode = DeviceModes.CONTROLLER
			current_device_changed.emit()
	elif current_device_mode == DeviceModes.CONTROLLER:
		if (event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventMouseMotion):
			current_device_mode = DeviceModes.KEYBOARD
			current_device_changed.emit()
