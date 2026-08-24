extends RichTextLabel

func _init() -> void:
	text = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Debug mode toggling
	DwUtils.debug_mode_changed.connect(func() -> void:
		visible = DwUtils.debug_mode)

func _process(_delta: float) -> void:
	text = ""
	if !DwUtils.debug_mode: return # debug mode not enabled
	
	if DwGlobal.player:
		var _player_pos := DwGlobal.player.global_position
		var _pos_str := (str(snapped(_player_pos.x, 0.1))
			+ ", " + str(snapped(_player_pos.y, 0.1))
			+ ", " + str(snapped(_player_pos.z, 0.1)))
		text += _pos_str
	
	text += "\nToolMode." + DwGadget.ToolMode.find_key(DwGadget.tool_mode)
