extends CanvasLayer
# HUD
# Handles and updates HUD elements; also collects some debug data

const SmokeTransition = preload("res://lib/ui/hud/smoke_transition/smoke_transition.tscn")
const Aberration = preload("res://lib/ui/hud/aberration/aberration.tscn")
const Thingistry = preload("res://lib/thingistry/thingistry.tscn")

# Box dissolving - gets and controls the 'dissolve' of the object box and lerps
# smoothly between values (see _process() as well)
var _target_oibox_dissolve := 0.0
var _oibox_dissolve := 0.0

func _get_oibox_dissolve() -> float:
	return(float($Sidebar/OIBox.material.get_shader_parameter("exp")))
func _set_oibox_dissolve(_v: float):
	$Sidebar/OIBox.material.set_shader_parameter("exp", (1.0 - _oibox_dissolve) * 10.0)
	$Sidebar/OIBox.material.set_shader_parameter("alpha", _oibox_dissolve)

# Replace text in-between '<' and '>' with colour
func _fmt_color_tags(input: String) -> String:
	var output = input.replace("<", "[color=yellow]")
	output = output.replace(">", "[/color]")
	return(output)

func open_thingistry() -> void:
	if Global.in_exclusive_ui: return
	var _thingistry = Thingistry.instantiate()
	add_child(_thingistry)
	_thingistry.go_to_page(0)

func _ready() -> void:
	# Establish visibilty and modulation
	_target_oibox_dissolve = 0.0
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
		_target_oibox_dissolve = 1.0
		$Sidebar/OIBox/OIHeading/OITitle.text = Global.proximal_object.title
		$Sidebar/OIBox/OIBody.text = _fmt_color_tags(Global.proximal_object.description))
	
	Global.proximity_left.connect(func():
		_target_oibox_dissolve = 0.0)
	
	Global.shake_camera.connect(func(): # chromatic aberration for camera shake
		var aberration = Aberration.instantiate()
		add_child(aberration))
	
	Global.hud_toggle_hidden.connect(func(state):
		visible = !state)
	
	# Use setting_changed to trigger an update to display of the map name,
	# because we know the map name is set before this signal is called
	SettingsHandler.setting_changed.connect(func(_parameter):
		if Global.target_scene_description != null:
			$Sidebar/MTBox/MTBody.text = Global.target_scene_description
		$Sidebar/MTBox/MTHeading/MTTitle.text = Global.target_scene_title)
	
	# Thingistry toggling of curio notification
	Global.interaction_ended.connect(func():
		for _c in Curio.DATA:
			if "objects" in Curio.DATA[_c]:
				if Curio.last_collected in Curio.DATA[_c].objects:
					var _thingistry = Thingistry.instantiate()
					add_child(_thingistry)
					_thingistry.go_to_id(_c)
					break
		Curio.last_collected = "")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_key"):
		Global.set_display_debug(!Global.debug_visible)
	
	if Input.is_action_just_pressed("thingistry"):
		open_thingistry()
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.in_exclusive_ui: return
		if !$Settings.is_open: $Settings.open()
		else: $Settings.close()

func _process(delta: float) -> void:
	_oibox_dissolve = lerp(_oibox_dissolve, _target_oibox_dissolve, delta * 13.0)
	_set_oibox_dissolve(_oibox_dissolve)

func _on_interact_button_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		if Global.in_exclusive_ui: return
		Global.interact_pressed.emit()
	if Input.is_action_just_released("left_click"):
		Global.interact_released.emit() # for object hold circles

func _on_settings_pressed() -> void:
	if Global.in_exclusive_ui: return
	if !$Settings.is_open: $Settings.open()
	else: $Settings.close()

func _on_thingistry_pressed() -> void:
	open_thingistry()

func _on_close_button_button_down() -> void:
	get_tree().quit()
