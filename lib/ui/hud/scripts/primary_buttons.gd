extends Control
# Handle logic for primary buttons - mainly whether they are enabled or not
# (e.g., only claim if the gadget you are closest to is in a position to be claimed)

func disable_button(button: BaseButton) -> void:
	button.disabled = true
	button.modulate = Color(1.0, 1.0, 1.0)

func enable_button(button: BaseButton) -> void:
	button.disabled = false

func _ready() -> void:
	# Set up button hover and click UI states
	for _n: TextureButton in get_children():
		_n.pressed.connect(func() -> void:
			Dwelt.emit_click_sound.emit())
		_n.mouse_entered.connect(func() -> void:
			if !_n.disabled:
				_n.modulate = Color(1.5, 1.5, 1.5))
		_n.mouse_exited.connect(func() -> void:
			_n.modulate = Color(1.0, 1.0, 1.0))
	
	Dwelt.selected_gadget_changed.connect(func(gadget: Gadget) -> void:
		if !gadget:
			disable_button($Claim)
			disable_button($Interact)
			return
		elif gadget in Dwelt.gadgets_close_to_player:
			enable_button($Claim)
			enable_button($Interact)
		else:
			disable_button($Claim)
			disable_button($Interact))
	
	Dwelt.gadgets_close_to_player_changed.connect(func() -> void:
		# Only using this to check that there are close gadgets; not really
		# concerned about the *closest* one
		if Dwelt.get_closest_gadget(): 
			if (Dwelt.selected_gadget in Dwelt.gadgets_close_to_player
				and Dwelt.selected_gadget.get_effect("enemy_owned")):
				enable_button($Claim)
			else: disable_button($Claim)
			if (Dwelt.selected_gadget in Dwelt.gadgets_close_to_player
				and Dwelt.selected_gadget.interactive):
				enable_button($Interact)
			else: disable_button($Interact)
		else:
			disable_button($Claim)
			disable_button($Interact))
	
	await get_tree().process_frame
	if Dwelt.player_effect_manager.has_effect("resilience"):
		enable_button($Build)

# TODO: this logic needs to be centralised somewhere
func _input(_event: InputEvent) -> void:
	if !Dwelt.selected_gadget in Dwelt.gadgets_close_to_player: return
	
	if Input.is_action_just_pressed("claim"): _on_claim_pressed()
	elif Input.is_action_just_pressed("interact"): _on_interact_pressed()

# Cannot be pressed unless it is actually valid
func _on_claim_pressed() -> void:
	if Dwelt.selected_gadget.get_effect("enemy_owned"):
		Dwelt.claim_requested.emit()

func _on_build_pressed() -> void:
	if BOps.mode == BOps.Mode.INACTIVE: BOps.activate()
	else: BOps.deactivate()

func _on_interact_pressed() -> void:
	if Dwelt.selected_gadget.interactive:
		Dwelt.captured_pane_open.emit(
			Dwelt.selected_gadget.interactive_captured_scene)
