extends TextureRect

func _ready() -> void:
	DweltInput.current_device_changed.connect(func() -> void:
		if DweltInput.current_device_mode == DweltInput.DeviceModes.CONTROLLER:
			visible = true
		elif DweltInput.current_device_mode == DweltInput.DeviceModes.KEYBOARD:
			visible = false)
