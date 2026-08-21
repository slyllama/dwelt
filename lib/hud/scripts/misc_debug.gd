extends RichTextLabel

func _init() -> void:
	text = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Debug mode toggling
	DwUtils.debug_mode_changed.connect(func() -> void:
		visible = DwUtils.debug_mode)

func _process(_delta: float) -> void:
	if !DwUtils.debug_mode: return # debug mode not enabled
	text = "ToolMode." + DwGlobal.ToolMode.find_key(DwGlobal.tool_mode)
