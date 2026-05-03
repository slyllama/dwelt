@icon("res://generic/icons/EffectManager.svg")
class_name EffectManager extends Node

var active_effects: Dictionary[String, EffectInstance]

signal effect_added(id: String)
signal effect_decremented(id: String)
signal effect_finished(id: String)
signal effects_updated()
signal effect_cancelled(id: String)

func notify_update() -> void:
	effects_updated.emit()
	if Dwelt.selected_gadget == get_parent():
		Dwelt.selected_gadget_updated.emit()

func has_effect(id: String) -> bool:
	return(id in active_effects)

# Return the gadget's current effects and durations/quantities in a way that
# can be stored in the save file
func get_effects_as_dict() -> Dictionary:
	var _dict := {}
	for id in active_effects:
		var effect := active_effects[id]
		_dict[effect.id] = {}
		if effect.type == effect.Type.DURATION:
			_dict[effect.id]["current_duration"] = str(
				snapped(effect.current_duration, 0.01))
		elif effect.type == effect.Type.QUANTITY:
			_dict[effect.id]["current_quantity"] = str(effect.current_quantity)
	return(_dict)

func apply_effects_from_dict(effect_dict: Dictionary) -> void:
	for _eid: String in effect_dict:
		var _effect_path: String = Dwelt.EFFECTS_PATH + _eid + ".tres"
		if !FileAccess.file_exists(_effect_path):
			Utils.pdebug("Couldn't apply effect '" + _eid + "' because it has no resource.",
				"EffectManager")
			continue
		var _effect_data: Dictionary = effect_dict[_eid]
		var _effect: EffectInstance = load(_effect_path).duplicate()
		
		if "current_duration" in _effect_data:
			add_effect(_effect, float(_effect_data.current_duration))
		if "current_quantity" in _effect_data:
			add_effect(_effect, int(_effect_data.current_quantity))

func decrement_effect_qty(id: String) -> void:
	if id in active_effects:
		effect_decremented.emit(id)
		var effect := active_effects[id]
		if effect.type == effect.Type.QUANTITY:
			effect.current_quantity -= 1
			if effect.current_quantity <= 0:
				cancel_effect(id)
			else: notify_update()

# Effect quantities and duration can be set by passing it here. If not, it will
# be added using default total values
func add_effect(effect: EffectInstance,
	current_duration := effect.total_duration,
	current_quantity := effect.total_quantity) -> void:
	
	var id := effect.id
	# If an effect with this ID isn't already active, add it
	if !id in active_effects:
		active_effects[id] = effect.duplicate()
		active_effects[id].current_duration = current_duration
		active_effects[id].current_quantity = current_quantity
		
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
		notify_update()

func cancel_effect(id: String) -> void:
	if id in active_effects:
		var effect := active_effects[id]
		effect.finished.emit()
		effect_cancelled.emit(id)
		active_effects.erase(id)
		notify_update()

func _process(delta: float) -> void:
	for id in active_effects:
		var effect := active_effects[id]
		effect.current_duration -= delta
		if effect.type == EffectInstance.Type.DURATION:
			if effect.current_duration <= 0:
				effect_finished.emit(id)
				effect.finished.emit()
				active_effects.erase(id)
				notify_update()
