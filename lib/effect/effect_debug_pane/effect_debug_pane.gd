@tool
extends UIPane

@export var effect_manager: EffectManager

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
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
		effect_manager.add_effect(load("res://test_duration_effect.tres"))

func _on_add_qty_effect_pressed() -> void:
	if effect_manager:
		effect_manager.add_effect(load("res://test_quantity_effect.tres"))
