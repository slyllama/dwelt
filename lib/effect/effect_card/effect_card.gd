class_name EffectCard extends VBoxContainer

@export var effect_instance: EffectInstance:
	set(_effect_instance):
		effect_instance = _effect_instance
		if effect_instance:
			effect_instance.finished.connect(queue_free)
			if effect_instance.icon: $Icon.texture = effect_instance.icon

func _ready() -> void:
	await get_tree().process_frame
	Dwelt.play_flash.emit($Icon.global_position)

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
			var quantity := effect_instance.current_quantity
			
			# Hide text if it has a quantity of 1
			# TODO: this might be able to be more efficient
			if quantity == 1:
				if effect_instance.hide_single_quantity:
					$Text.modulate.a = 0.0
			else: $Text.modulate.a = 1.0
			$Text.text += str(snapped(quantity, 1))
		
		$Icon.position = $Frame.position + $Frame.size / 2.0
