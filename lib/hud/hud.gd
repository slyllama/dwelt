extends CanvasLayer
# HUD
# Draws game UI elements on screen

@onready var interact_label = $InteractLabel/InteractContainer/Text
@onready var interact_icon = $InteractLabel/InteractContainer/ControllerIcon

func _ready() -> void:
	Reporter.gadget_changed.connect(func():
		if Reporter.current_gadget:
			var _r: Gadget = Reporter.current_gadget
			if _r.interact_text:
				interact_label.text = "[center]" + _r.interact_text + "[/center]"
			else: interact_label.text = "[center]Interact[/center]"
			$InteractLabel.dissolve_in()
		else: $InteractLabel.dissolve_out())
