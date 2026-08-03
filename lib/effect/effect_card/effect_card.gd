class_name EffectCard extends HBoxContainer
# Display an icon for a single effect

const PLACEHOLDER_TEXTURE := preload("res://data/effects/placeholder.jpg")

@export var effect_instance: EffectInstance:
	set(_effect_instance):
		effect_instance = _effect_instance
		if effect_instance:
			effect_instance.finished.connect(queue_free)
			
			%Title.text = effect_instance.title
			%Description.text = effect_instance.description
			if effect_instance.icon: %Icon.texture = effect_instance.icon
			else: %Icon.texture = PLACEHOLDER_TEXTURE

func _process(_delta: float) -> void:
	if effect_instance:
		if effect_instance.type == EffectInstance.Type.QUANTITY:
			var quantity := effect_instance.current_quantity
			if quantity == 1:
				if effect_instance.hide_single_quantity:
					%Qty.visible = false
			else: %Qty.visible = true
			%Qty.text = str(snapped(quantity, 1))
		elif effect_instance.type == EffectInstance.Type.DURATION:
			%Qty.visible = false
			
			# Render progress bar with remaining time
			%ProgressBarMask.visible = true
			%ProgressBar.value = (effect_instance.current_duration
				/ effect_instance.total_duration * 100.0)
