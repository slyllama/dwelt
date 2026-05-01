@icon("res://generic/icons/Gadget.svg")
class_name Gadget extends StaticBody3D
## Gadgets are the core building-blocks of [i]Dwelt[/i], capable of inflicting and receiving
## effects, and being manipulated by the player.
##
## Gadgets are always loaded, managed, and saved by the shard's [GadgetManager]. The manager gets
## its shard data from the save through [code]Save.save.shard_data[shard_id].gadgets[/code]. The
## gadgets aren't just injected straight into the scene; instead they are asynchronously requested
## by spawning [Async3DLoader] nodes. The loader's [method Async3DLoader.add_scene] function returns
## a reference to the resulting node, and so the [GadgetManager] connects to its
## [method GadgetManager.ready] signal to populate its effects via the effect manager's
## [method EffectManager.apply_effects_from_dict] function.[br]
##
## If the player is in a shard and the current gadget manager is set through
## [param Dwelt.gadget_manager], then saving Dwelt's save data to the JSON file will call
## [method GadgetManager.write_gadgets_to_save] first, because this does not happen automatically.
## [br]
##
## Gadget claiming is requested by the HUD's [code]PrimaryButtons[/code], which fires off
## [method Dwelt.claim_requested]. The player's [code]ClaimHandler[/code] is then actually
## responsible for adding the claiming effect to the player. If the effect finishes without
## interruption, the [code]ClaimHandler[/code] removes the [code]enemy_owned[/code] effect from the
## [code]claim_target[/code]. The player's [code]ClaimBeam[/code] is also listening into all of
## this, and updating the player's VFX.

@export var gadget_id := "gadget"
## The mesh collection associated with the gadget. Setting the gadget's [param model] value is
## important as it uses this reference to cull meshes and more. A gadget doesn’t come with an
## [EffectManager] by default; if one isn't specified, it will become a non-dynamic, and not take
## up resources it doesn't need to.
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
@onready var enemy_indicator: Sprite3D

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
		
		# If the player moves out of range, cancel claiming this gadget (if it
		# is in the process of being claimed)
		_proximity_area.body_exited.connect(func(body: PhysicsBody3D) -> void:
			if body is DweltPlayer and Dwelt.claim_target == self:
				if Dwelt.player_effect_manager.has_effect("claiming"):
					Utils.pdebug("Claim cancelled (moved too far from gadget).", "Gadget/ProximityArea")
					Dwelt.player_effect_manager.cancel_effect("claiming"))
		
		# Logic for showing and removing the "enemy owned" indicator
		await get_tree().process_frame
		if effect_manager.has_effect("enemy_owned"):
			enemy_indicator = load(
				"res://lib/gadget/enemy_indicator/enemy_indicator.tscn").instantiate()
			enemy_indicator.position.y = 0.5
			add_child(enemy_indicator)
			effect_manager.effect_cancelled.connect(func(id: String) -> void:
				if id == "enemy_owned" and enemy_indicator:
					enemy_indicator.free())
