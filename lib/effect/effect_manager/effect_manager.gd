class_name EffectManager extends Node
# The EffectManager is responsible for tracking a gadget's active effects, and
# their durations and quantities:
#
# <effect ID>: {
#	"qty": <quantity - optional>,
#	"time_left": <remaining time - optional>
# }

const TICK := 0.1

var effects := {
	"test_effect": { "time_left": "5.0" },
	"qty_effect": { "qty": "10" }
}

var _t := 0.0 # time

func add_time_effect(id: String, time_left: float) -> void:
	effects[id] = { "time_left": str(snapped(time_left, TICK)) }

func _process(delta: float) -> void:
	if _t > TICK:
		_t = 0
		# Decrement effect times if they have that property
		for _e: String in effects:
			var effect: Dictionary = effects[_e]
			if "time_left" in effect:
				var time_left: float = effect.time_left.to_float()
				if time_left > 0.0:
					time_left -= TICK
					effect.time_left = str(snapped(time_left, 0.1))
				else: effects.erase(_e)
	_t += delta
