extends CanvasLayer
# HUD
# Handles and updates HUD elements; also collects some debug data

const SmokeTransition = preload("res://lib/ui/hud/smoke_transition/smoke_transition.tscn")
const Aberration = preload("res://lib/ui/hud/aberration/aberration.tscn")

# Replace text in-between '<' and '>' with colour
func _fmt_color_tags(input: String) -> String:
	var output = input.replace("<", "[color=yellow]")
	output = output.replace(">", "[/color]")
	return(output)

func _ready() -> void:
	# Establish visibilty and modulation
	$Minimap/InteractButton.visible = false
	$Sidebar.visible = false
	$FG.visible = true

	# Fade from black
	var smoke_transition = SmokeTransition.instantiate()
	add_child(smoke_transition)
	
	var fade_tween = create_tween()
	fade_tween.tween_property($FG, "self_modulate:a", 0.0, 0.6)
	fade_tween.tween_callback(func():
		$FG.queue_free()
		smoke_transition.fade_out())
	
	Global.proximity_entered.connect(func():
		$Sidebar.visible = true
		$Sidebar/Heading/Title.text = Global.proximal_object.title
		$Sidebar/Info.text = _fmt_color_tags(Global.proximal_object.description)
		if Global.proximal_object.can_interact:
			# Interact button will glow on fade in
			$Minimap/InteractButton.fade_in(true)
		else: $Minimap/InteractButton.fade_out())
	
	Global.proximity_left.connect(func():
		$Minimap/InteractButton.fade_out()
		$Sidebar.visible = false)
	
	Global.shake_camera.connect(func(): # chromatic aberration for camera shake
		var aberration = Aberration.instantiate()
		add_child(aberration))

func _on_settings_pressed() -> void:
	if !$Settings.is_open: $Settings.open()
	else: $Settings.close()

func _on_interact_pressed() -> void:
	Global.interact_pressed.emit()

# Toggle debug with settings
func _on_settings_closed() -> void: $Minimap/DebugContainer.visible = false
func _on_settings_opened() -> void: $Minimap/DebugContainer.visible = true
