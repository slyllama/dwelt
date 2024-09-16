extends CanvasLayer
# HUD
# Handles and updates HUD elements

func _fmt_fps() -> String:
	var fps = Engine.get_frames_per_second()
	var color = "green"
	if fps < 30: color = "red"
	elif fps < 60: color = "yellow"
	return("[color=" + color + "]" + str(fps) + "fps[/color]")

# Replace text in-between '<' and '>' with colour
func _fmt_color_tags(input: String) -> String:
	var output = input.replace("<", "[color=yellow]")
	output = output.replace(">", "[/color]")
	return(output)

func _ready() -> void:
	# Establish visibilty
	$InteractSign.visible = false
	$Sidebar.visible = false
	
	Global.proximity_entered.connect(func():
		$Sidebar.visible = true
		$Sidebar/Heading/Title.text = Global.proximal_object.title
		$Sidebar/Info.text = _fmt_color_tags(Global.proximal_object.description)
		
		$InteractSign.text = "[center]" + Global.proximal_object.interact_string + "[/center]"
		if Global.proximal_object.can_interact: $InteractSign.visible = true
		else: $InteractSign.visible = false)
	
	Global.proximity_left.connect(func():
		$InteractSign.visible = false
		$Sidebar.visible = false)

func _process(_delta: float) -> void:
	$Debug.text = _fmt_fps() + "\n[font_size=2] [/font_size]"
	$Debug.text += "\n" + Utilities.fmt_vec3(Global.player_position)
	if Global.proximal_object.id != "none":
		$Debug.text += "\nproximal_object.id = " + Global.proximal_object.id
	if Global.active_pylon.id != "none":
		$Debug.text += "\nactive_pylon.id = " + Global.active_pylon.id

func _on_fade_finished(_anim_name: StringName) -> void:
	$FadeIn.queue_free()
