@icon("res://generic/icons/EffectControl.svg")
class_name EffectTooltip extends PanelContainer

const PLACEHOLDER_TEXTURE := preload("res://data/effects/placeholder.jpg")

@export var effect_instance: EffectInstance:
	set(_effect_instance):
		effect_instance = _effect_instance
		if effect_instance:
			effect_instance.finished.connect(queue_free)
			
			# Populate
			%Title.text = effect_instance.title
			%Description.text = effect_instance.description
			if effect_instance.icon: %Icon.texture = effect_instance.icon
			else: %Icon.texture = PLACEHOLDER_TEXTURE
