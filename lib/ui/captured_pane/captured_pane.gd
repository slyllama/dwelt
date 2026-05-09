extends CanvasLayer

var active := false

func open() -> void:
	if active: return # don't repeat
	
	active = true
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close() -> void:
	if !active: return # don't repeat
	
	await get_tree().process_frame
	active = false
	visible = false
	get_tree().paused = false

func _ready() -> void:
	$DebugBG.visible = false
	
	Dwelt.captured_pane_open.connect(open)
	
	# TODO: debug
	Utils.debug_sent.connect(func(cmd: String) -> void:
		if cmd == "/testcapturedpane":
			Dwelt.captured_pane_open.emit())

func _input(_event: InputEvent) -> void:
	if !visible: return
	if (Input.is_action_just_pressed("ui_cancel")
		and Dwelt.ui_pane_manager.panes.size() == 0):
		close()
