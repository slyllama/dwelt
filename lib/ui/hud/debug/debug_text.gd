extends RichTextLabel

func _fmt_fps() -> String:
	var fps = Engine.get_frames_per_second()
	var color = "green"
	if fps < 30: color = "red"
	elif fps < 60: color = "yellow"
	return("[color=" + color + "]" + str(fps) + "fps[/color]")

func update() -> void:
	var primitives = str(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))
	text = _fmt_fps()
	text += "\nprimitives = " + primitives
	text += "\n[font_size=4] [/font_size]"
	text += "\nplayer_position = " + Utilities.fmt_vec3(Global.player_position)
	text += "\nfoliage_count = " + str(Global.foliage_count)
	if Global.proximal_object.id != "none":
		text += "\nproximal_object.id = " + Global.proximal_object.id
	if Global.active_pylon.id != "none":
		text += "\nactive_pylon.id = " + Global.active_pylon.id

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	if time > 0.1:
		time = 0.0
		update()
