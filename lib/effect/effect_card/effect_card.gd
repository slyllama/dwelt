extends VBoxContainer

@export var effect_instance: EffectInstance:
	set(_effect_instance):
		effect_instance = _effect_instance
		if effect_instance:
			effect_instance.finished.connect(queue_free)
			if effect_instance.icon: $Icon.texture = effect_instance.icon

func _process(_delta: float) -> void:
	
	if effect_instance:
		$Text.text = ""
		if effect_instance.type == EffectInstance.Type.DURATION:
			var _current_duration := effect_instance.current_duration
			if _current_duration < 2.0:
				$Text.text += str(snapped(_current_duration, 0.1)) + "s"
			else:
				$Text.text += str(snapped(_current_duration, 1)) + "s"
		elif effect_instance.type == EffectInstance.Type.QUANTITY:
			$Text.text += str(snapped(effect_instance.current_quantity, 1))
		
		$Icon.position = $Frame.position + $Frame.size / 2.0
