extends PanelContainer

const SLOT_COUNT = 8

func handle_button_event(id: String) -> void:
	Dwelt.click_sound_requested.emit()
	match id:
		"exit_build": BOps.change_mode(BOps.Mode.INACTIVE)

func _ready() -> void:
	# Connect mode change updates
	BOps.mode_changed.connect(func() -> void:
		if BOps.mode == BOps.Mode.INACTIVE:
			visible = false
		else: visible = true)
	
	visible = false # hide
	
	# Generate button slots
	for _s in SLOT_COUNT:
		var _button := BOpsButton.new()
		_button.pressed.connect(func() -> void:
			handle_button_event(_button.button_id))
		%Box.add_child(_button)
	
	%Box.get_child(%Box.get_child_count() - 1).button_id = "exit_build"
	%Box.get_child(%Box.get_child_count() - 1).text = "Done"
