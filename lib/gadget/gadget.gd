class_name Gadget extends CollisionObject3D
# Base class for all gadgets

@export var gadget_id := "gadget"
@export var effect_manager: EffectManager

func _ready() -> void:
	# Set flag to allow camera pushing
	#set_collision_layer_value(2, true)
	
	# Populate with an EffectManager if one wasn't nominated
	if !effect_manager:
		effect_manager = EffectManager.new()
