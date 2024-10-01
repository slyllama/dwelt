extends "res://lib/ui/ui_container/ui_container.gd"
# MinimapTool
# A tool for configuring the position, scale, and rotation of minimaps


func _ready() -> void:
	super()
	Global.minimap_refresh.connect(func():
		# Update the debug code, which prints straight from global on change
		$Container/Debug.text = ""
		for d in Global.minimap_data:
			$Container/Debug.text += str(d) + ": " + str(Global.minimap_data[d]) + "\n"
		
		# Set sliders
		$Container/OffsetX.set_value(Global.minimap_data["offset_x"])
		$Container/OffsetY.set_value(Global.minimap_data["offset_y"])
		$Container/Magnitude.set_value(Global.minimap_data["magnitude"])
		$Container/Rotation.set_value(Global.minimap_data["image_rotation"])
		$Container/ImageScale.set_value(Global.minimap_data["image_scale"]))
	Global.minimap_refresh.emit()

func _on_offset_x_value_changed(value: Variant) -> void:
	Global.minimap_data["offset_x"] = value
	Global.minimap_refresh.emit()

func _on_offset_y_value_changed(value: Variant) -> void:
	Global.minimap_data["offset_y"] = value
	Global.minimap_refresh.emit()

func _on_image_scale_value_changed(value: Variant) -> void:
	Global.minimap_data["image_scale"] = value
	Global.minimap_refresh.emit()

func _on_rotation_value_changed(value: Variant) -> void:
	Global.minimap_data["image_rotation"] = value
	Global.minimap_refresh.emit()

func _on_magnitude_value_changed(value: Variant) -> void:
	Global.minimap_data["magnitude"] = value
	Global.minimap_refresh.emit()

func _on_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(
		str(Global.minimap_data).replace("\"bg_color\": ", "\"bg_color\": Color"))
