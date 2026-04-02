class_name EffectManager extends Node

var active_effects: Dictionary[String, EffectInstance]

func add_effect(effect: EffectInstance) -> void:
	var id := effect.id
	# If an effect with this ID isn't already active, add it
	if !id in active_effects:
		active_effects[id] = effect
	else: # logic for 'compounding' an existing effect
		var existing_effect := active_effects[id]
		if effect.type == EffectInstance.Type.DURATION:
			if effect.duration_stacks:
				existing_effect.current_duration += effect.total_duration
			else: existing_effect.current_duration = effect.total_duration
		elif effect.type == EffectInstance.Type.QUANTITY:
			if effect.quantity_stacks:
				existing_effect.current_quantity += effect.total_quantity
			else: existing_effect.current_quantity = effect.total_quantity

func _process(delta: float) -> void:
	for _e in active_effects:
		var effect := active_effects[_e]
		effect.current_duration -= delta
		if effect.type == EffectInstance.Type.DURATION:
			if effect.current_duration <= 0:
				active_effects.erase(_e)
