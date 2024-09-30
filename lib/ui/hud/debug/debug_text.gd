extends RichTextLabel

func _fmt_fps() -> String:
	var fps = Engine.get_frames_per_second()
	var color = "green"
	if fps < 30: color = "red"
	elif fps < 60: color = "yellow"
	return("[color=" + color + "]" + str(fps) + "fps[/color]")

func update() -> void:
	var primitives = str(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	text = "[right]" + _fmt_fps()
	text += "\nprimitives = " + primitives
	text += "\nfoliage_count = " + str(Global.foliage_count)
	text += "\n[font_size=4] [/font_size]"
	if Global.proximal_object.id != "none":
		text += "\n[color=yellow]proximal_object.id = " + Global.proximal_object.id + "[/color]"
	if Global.active_pylon.id != "none":
		text += "\n[color=yellow]active_pylon.id = " + Global.active_pylon.id + "[/color]"
	
	text += "[/right]"

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	if time > 0.1:
		time = 0.0
		update()
