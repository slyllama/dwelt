extends CanvasLayer
# HUD
# Draws game UI elements on screen

func _ready() -> void:
	Reporter.gadget_changed.connect(func():
		await get_tree().process_frame
		$InteractLabel.visible = (Reporter.current_gadget != null))
