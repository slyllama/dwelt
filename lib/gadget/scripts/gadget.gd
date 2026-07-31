@icon("res://generic/icons/Gadget.svg")
class_name Gadget extends StaticBody3D

@export var gadget_id := "gadget"
@export var model: Node3D
@export var effect_manager: EffectManager
@export var player_collision := true:
	set(_player_collision):
		player_collision = _player_collision
		update_collision_layers()

@export_category("Culling and Visibility")
@export var cull_distance := 5.0:
	set(_cull_distance):
		cull_distance = _cull_distance
		if cull_handler:
			cull_handler.cull_distance = cull_distance
@export var pushes_camera := false:
	set(_pushes_camera):
		pushes_camera = _pushes_camera
		update_collision_layers()

@onready var cull_handler := CullHandler.new()
@onready var hover_handler := HoverHandler.new()

signal player_entered_active_area
signal player_exited_active_area
var player_in_active_area := false
var enemy_indicator: Decal

# Gets an effect by ID if the gadget has an effect manager which includes that
# effect = or returns `null` otherwise
#func get_effect(effect_id: String) -> Variant:
	#if effect_manager:
		#if effect_id in effect_manager.active_effects:
			#return(effect_manager.active_effects[effect_id])
		#else: return(null)
	#else: return(null)

func update_collision_layers() -> void:
	# Layer 3 is used for all interaction testing (including mouseover)
	set_collision_layer_value(3, true)
	
	if player_collision: set_collision_layer_value(1, true)
	else: set_collision_layer_value(1, false)
	if pushes_camera: set_collision_layer_value(2, true)
	else: set_collision_layer_value(2, false)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	update_collision_layers()
	
	if model:
		add_child(cull_handler)
		cull_handler.cull_model = model
		cull_handler.cull_distance = cull_distance
		
		hover_handler.hover_shape = self
		hover_handler.hover_model = model
		add_child(hover_handler)
