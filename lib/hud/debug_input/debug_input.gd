extends PanelContainer
# DebugInput
# Used for inputting debug command and seeing their results

const INACTIVE_ALPHA := 0.5

func _ready() -> void:
	modulate.a = INACTIVE_ALPHA
	Utils.pdebug_sent.connect(func(string: String) -> void:
		%Output.text += "\n" + string)

func _input(_event: InputEvent) -> void:
	# Toggle input focusing
	if Input.is_action_just_pressed("debug_prefix"):
		%Input.grab_focus()
	
	# Handle sending debug commands (or cancelling input)
	if %Input.has_focus():
		if Input.is_action_just_pressed("ui_accept"):
			Utils.debug_sent.emit(%Input.text)
			%Input.text = ""
			get_window().gui_release_focus()
		elif Input.is_action_just_pressed("ui_cancel"):
			if %Input.text == "/": %Input.text = ""
			get_window().gui_release_focus()

func _on_input_focus_entered() -> void:
	modulate.a = 1.0

func _on_input_focus_exited() -> void:
	modulate.a = INACTIVE_ALPHA
