class_name Gadget extends StaticBody3D
# Base class for all gadgets

@export var gadget_id := "gadget"
@export var model: Node3D
@export var effect_manager: EffectManager
@export var interactable := false

@export_category("Culling")
@export var cull_distance := 5.0:
	set(_cull_distance):
		cull_distance = _cull_distance
		if cull_handler:
			cull_handler.cull_distance = cull_distance

@onready var cull_handler := CullHandler.new()
@onready var hover_handler := HoverHandler.new()

func _ready() -> void:
	set_collision_layer_value(2, true)
	
	if model:
		add_child(cull_handler)
		cull_handler.cull_model = model
		cull_handler.cull_distance = cull_distance
		
		hover_handler.hover_shape = self
		hover_handler.hover_model = model
		add_child(hover_handler)
	
	if interactable:
		var _proximity_area := ProximityArea.new()
		add_child(_proximity_area)
