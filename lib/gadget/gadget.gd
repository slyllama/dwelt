class_name Gadget extends StaticBody3D
# Base class for all gadgets

@export var gadget_id := "gadget"
@export var model: Node3D
@export var effect_manager: EffectManager

@export_category("Culling")
@export var cull_distance := 5.0:
	set(_cull_distance):
		if cull_handler:
			cull_handler.cull_distance = cull_distance

@onready var cull_handler := CullHandler.new()

func _ready() -> void:
	if model:
		cull_handler.cull_model = model
		add_child(cull_handler)
		cull_handler.cull_distance = cull_distance
