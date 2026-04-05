@tool
extends UIPane

@export var effect_manager: EffectManager:
	set(_effect_manager):
		effect_manager = _effect_manager
		%EffectCardManager.effect_manager = effect_manager

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	Dwelt.selected_gadget_changed.connect(func(gadget: Gadget) -> void:
		%DebugText.text = ""
		if gadget:
			effect_manager = gadget.effect_manager
			if !effect_manager:
				%DebugText.text = "No registered effect manager."
		else: effect_manager = null)

func _process(_delta: float) -> void:
	super(_delta)
	
	if effect_manager:
		%DebugText.text = str(effect_manager)
		var active_effects := effect_manager.active_effects
		for id: String in active_effects:
			var effect: EffectInstance = active_effects[id]
			%DebugText.text += "\n\t" + id
			if effect.type == EffectInstance.Type.DURATION:
				%DebugText.text += (" ("
					+ str(snapped(effect.current_duration, 0.1))
					+ "s/" + str(snapped(effect.total_duration, 0.1)) + "s)")
			elif effect.type == EffectInstance.Type.QUANTITY:
				%DebugText.text += (" ("
					+ str(snapped(effect.current_quantity, 1)) + ")")

func _on_add_timed_effect_pressed() -> void:
	if effect_manager:
		effect_manager.add_effect(load(
			"res://test_duration_effect.tres"))

func _on_add_qty_effect_pressed() -> void:
	if effect_manager:
		effect_manager.add_effect(load(
			"res://test_quantity_effect.tres"))

func _on_clear_pressed() -> void:
	effect_manager = null

func _on_set_to_player_pressed() -> void:
	effect_manager = Dwelt.player_effect_manager
	Dwelt.update_selected_gadget(null)
