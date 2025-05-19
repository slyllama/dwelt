extends CanvasLayer
# HUD
# Draws game UI elements on screen

func _ready() -> void:
	Reporter.gadget_changed.connect(func():
		if Reporter.current_gadget:
			var _r: Gadget = Reporter.current_gadget
			if _r.interact_text:
				$InteractLabel/InteractText.text = "[center]" + _r.interact_text + "[/center]"
			else: $InteractLabel/InteractText.text = "[center]Interact[/center]"
			$InteractLabel.dissolve_in()
		else: $InteractLabel.dissolve_out())
