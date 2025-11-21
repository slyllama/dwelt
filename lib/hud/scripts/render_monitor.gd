extends Label
# Monitor various rendering aspects such as FPS and primitive draw calls

var _c := 0
func _process(_delta: float) -> void:
	_c += 1
	if _c >= 3: _c = 0
	else: return # don't run every frame
	
	var _fps := Engine.get_frames_per_second()
	var _prim := Performance.get_monitor(
		Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	text = str(snapped(_fps, 1)) + " FPS (" + str(snapped(_prim, 1)) + ")"
