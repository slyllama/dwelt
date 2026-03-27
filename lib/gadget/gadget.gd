class_name Gadget extends StaticBody3D
# Base class for all gadgets

@export var gadget_id := "gadget"
@export var model: Node3D
@export var effect_manager: EffectManager

@export_category("Culling")
@export var cull_distance := 5.0:
	set(_cull_distance):
		cull_distance = _cull_distance
		if cull_handler:
			cull_handler.cull_distance = cull_distance

@onready var cull_handler := CullHandler.new()
@onready var debug_title := SpatialText.new()

func _ready() -> void:
	# Configure debug title
	add_child(debug_title)
	debug_title.text = gadget_id
	debug_title.debug_only = true
	
	if model:
		add_child(cull_handler)
		cull_handler.cull_model = model
		cull_handler.cull_distance = cull_distance
