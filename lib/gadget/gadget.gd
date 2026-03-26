class_name Gadget extends CollisionObject3D
# Base class for all gadgets

@export var gadget_id := "gadget"

@onready var effect_manager: EffectManager = EffectManager.new()

func _ready() -> void:
	add_child(effect_manager)
