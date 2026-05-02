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
## Scaled size of the red ring which appears when this gadget does not belong to the player.
@export var enemy_indicator_scale := 1.0

@export_category("Ownership and Claiming")
@export var claim_radius := 2.4
@export var claim_duration := 12.0

@onready var cull_handler := CullHandler.new()
@onready var hover_handler := HoverHandler.new()
@onready var enemy_indicator: Sprite3D

signal player_entered_active_area
signal player_exited_active_area

# Gets an effect by ID if the gadget has an effect manager which includes that
# effect = or returns `null` otherwise
func get_effect(effect_id: String) -> Variant:
	if effect_manager:
		if effect_id in effect_manager.active_effects:
			return(effect_manager.active_effects[effect_id])
		else: return(null)
	else: return(null)

func update_collision_layers() -> void:
	# Layer 3 is used for all interaction testing (including mouseover)
	set_collision_layer_value(3, true)
	
	if player_collision: set_collision_layer_value(1, true)
	else: set_collision_layer_value(1, false)
	if pushes_camera: set_collision_layer_value(2, true)
	else: set_collision_layer_value(2, false)

func _ready() -> void:
	update_collision_layers()
	
	if model:
		add_child(cull_handler)
		cull_handler.cull_model = model
		cull_handler.cull_distance = cull_distance
		
		hover_handler.hover_shape = self
		hover_handler.hover_model = model
		add_child(hover_handler)

	# Uses the inclusion of an effect manager to determine if the gadget
	# is interactive (i.e., needs to check the player's proximity to it)
	if effect_manager:
		var _proximity_area := ProximityArea.new()
		add_child(_proximity_area)
		_proximity_area.radius = claim_radius
		
		_proximity_area.body_entered.connect(func(body: PhysicsBody3D) -> void:
			if body is DweltPlayer:
				player_entered_active_area.emit())
		
		# If the player moves out of range, cancel claiming this gadget (if it
		# is in the process of being claimed)
		_proximity_area.body_exited.connect(func(body: PhysicsBody3D) -> void:
			if body is DweltPlayer:
				player_exited_active_area.emit()
			if body is DweltPlayer and Dwelt.claim_target == self:
				if Dwelt.player_effect_manager.has_effect("claiming"):
					Utils.pdebug("Claim cancelled (moved too far from gadget).",
						"Gadget/ProximityArea")
					Dwelt.player_effect_manager.cancel_effect("claiming"))
		
		# Logic for showing and removing the "enemy owned" indicator
		await get_tree().process_frame
		if effect_manager.has_effect("enemy_owned"):
			enemy_indicator = load(
				"res://lib/gadget/enemy_indicator/enemy_indicator.tscn").instantiate()
			enemy_indicator.pixel_size *= enemy_indicator_scale
			add_child(enemy_indicator)
			effect_manager.effect_cancelled.connect(func(id: String) -> void:
				if id == "enemy_owned" and enemy_indicator:
					enemy_indicator.free())
