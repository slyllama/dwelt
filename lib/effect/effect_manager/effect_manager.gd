class_name EffectManager extends Node

var active_effects: Dictionary[String, EffectInstance]

signal effect_added(id: String)
signal effect_finished(id: String)
signal effect_updated(id: String)

func add_effect(effect: EffectInstance) -> void:
	var id := effect.id
	# If an effect with this ID isn't already active, add it
	if !id in active_effects:
		active_effects[id] = effect.duplicate()
		# Reset effect quantities and durations
		active_effects[id].current_duration = active_effects[id].total_duration
		active_effects[id].current_quantity = active_effects[id].total_quantity
		effect_added.emit(id)
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
		effect_updated.emit()

func _process(delta: float) -> void:
	for id in active_effects:
		var effect := active_effects[id]
		effect.current_duration -= delta
		if effect.type == EffectInstance.Type.DURATION:
			if effect.current_duration <= 0:
				effect_finished.emit(id)
				effect.finished.emit()
				active_effects.erase(id)
