class_name Gadget extends CollisionObject3D
# Base class for all gadgets

@export var gadget_id := "gadget"
@export var effect_manager: EffectManager

func _ready() -> void:
	# Populate with an EffectManager if one wasn't nominated
	if !effect_manager:
		effect_manager = EffectManager.new()
