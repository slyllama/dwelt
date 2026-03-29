extends RichTextLabel
# Monitor various rendering aspects such as FPS and primitive draw calls

func _init() -> void:
	text = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Debug mode toggling
	Utils.debug_mode_changed.connect(func() -> void:
		visible = Utils.debug_mode)

var _c := 0
func update() -> void:
	_c += 1
	if _c >= 3: _c = 0
	else: return # don't run every frame
	
	# FPS
	var _fps := Engine.get_frames_per_second()
	var _color := "green"
	if _fps < Engine.max_fps: _color = "white"
	elif _fps < Engine.max_fps / 2.0: _color =  "yellow"
	elif _fps < 10: _color = "red"
	text = ("[color=" + _color + "]FPS: "
		+ str(snapped(_fps, 1)) + "[/color]")
	
	# Primitive count
	var _prim := Performance.get_monitor(
		Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	text += "\n Prims: " + str(snapped(_prim, 1))
	var _mem := Performance.get_monitor(
		Performance.RENDER_VIDEO_MEM_USED)
	text += "\n VRAM: " + str(snapped(_mem * 0.000001, 1)) + "MB"

func _process(_delta: float) -> void:
	if !Utils.debug_mode: return
	update()
