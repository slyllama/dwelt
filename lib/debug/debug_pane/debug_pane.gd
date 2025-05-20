extends RichTextLabel

func _render_fps() -> String: # pretty formatting of FPS values
	var color = "green"
	var _fps = Engine.get_frames_per_second()
	if _fps < 60: color = "yellow"
	elif _fps < 10: color = "red"
	return("[color=" + color + "]" + str(_fps) + "fps[/color]")

func render(debug_array: Array, clear_text = true, color = "white") -> void:
	var _i = 0
	var _color = "[color=" + color + "]"
	if clear_text: text = "[right]" + _color
	else: text += "[right]" + _color
	
	for _line in debug_array:
		if _i > 0: text += "\n"
		text += str(_line)
		_i += 1
	text += "[/color][/right]"

var _c = 0
func _process(delta: float) -> void:
	_c += delta
	if _c >= 0.1: # update every 100ms (not every frame)
		_c = 0
		var _prims = Performance.get_monitor( # get primitives
			Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
		render([
			_render_fps() + " (" + str(_prims) + ")",
			Utils.fmt_vec3(Reporter.player_position),
			"Reporter.orbiting = " + str(Reporter.orbiting),
			"Reporter.projectile_count = " + str(Reporter.projectile_count), "",
			"GameHandler.lives = " + str(GameHandler.lives)
		])
		
		if Reporter.current_gadget:
			render([
				"Reporter.current_gadget = " + str(Reporter.current_gadget)
			], false, "yellow")
