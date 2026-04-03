extends VBoxContainer

@export var effect_instance: EffectInstance:
	set(_effect_instance):
		effect_instance = _effect_instance
		if effect_instance:
			effect_instance.finished.connect(queue_free)

func _process(_delta: float) -> void:
	if effect_instance:
		$Text.text = effect_instance.id
		if effect_instance.type == EffectInstance.Type.DURATION:
			$Text.text += "\n(" + str(snapped(effect_instance.current_duration, 0.1)) + "s)"
		elif effect_instance.type == EffectInstance.Type.QUANTITY:
			$Text.text += "\n(" + str(snapped(effect_instance.current_quantity, 1)) + ")"
