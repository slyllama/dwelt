class_name EffectViewer extends RichTextLabel

@export var effect_manager: EffectManager

func _process(_delta: float) -> void:
	text = ""
	if effect_manager:
		for _e: String in effect_manager.effects:
			var effect: Dictionary = effect_manager.effects[_e]
			text += _e
			if "time_left" in effect:
				text += " (" + effect.time_left + ")\n"
			elif "qty" in effect:
				text += " (" + effect.qty + ")\n"
	text = text.strip_edges()
