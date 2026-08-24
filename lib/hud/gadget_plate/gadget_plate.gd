extends Control

func update(gadget: Gadget) -> void:
	if gadget:
		%Title.text = gadget.gadget_title
		if gadget.effect_manager:
			if !%EffectBar.effect_manager:
				await get_tree().process_frame
				visible = true
			%EffectBar.effect_manager = gadget.effect_manager
			%EffectTooltipBar.effect_manager = gadget.effect_manager
		else:
			%EffectBar.effect_manager = null
			%EffectTooltipBar.effect_manager = null
	else:
		%EffectBar.effect_manager = null
		%EffectTooltipBar.effect_manager = null
		visible = false

func _ready() -> void:
	DwGadget.hovered_gadget_changed.connect(update)
	%EffectTooltipBar.visible = false
	visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("inspect_effects"):
		%InspectIndicator.modulate = Color(0.5, 0.5, 0.5)
		%EffectTooltipBar.visible = true
	elif Input.is_action_just_released("inspect_effects"):
		%InspectIndicator.modulate = Color(1.0, 1.0, 1.0)
		%EffectTooltipBar.visible = false
