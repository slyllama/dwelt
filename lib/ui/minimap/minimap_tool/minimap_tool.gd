extends "res://lib/ui/ui_container/ui_container.gd"
# MinimapTool
# A tool for configuring the position, scale, and rotation of minimaps

func _ready() -> void:
	super()
	Global.minimap_refresh.connect(func():
		# Update the debug code, which prints straight from global on change
		$Container/Debug.text = ""
		for d in Global.minimap_data:
			$Container/Debug.text += str(d) + ": " + str(Global.minimap_data[d]) + "\n")
	Global.minimap_refresh.emit() # still needs to be done

# Copy Global.minimap_data to the clipboard so it can be used for map scripting
func _on_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(
		str(Global.minimap_data).replace("\"bg_color\": ", "\"bg_color\": Color"))
