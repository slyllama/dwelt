@tool
class_name Pylon extends Node3D

enum PYLON_TYPE { START, END }
const DIM = Color(0.5, 0.5, 0.5)

@export var debug_color = Color.YELLOW
@export var pylon_id = "test_pylon"
@export var pylon_type: PYLON_TYPE
@export var bound = false
@export var sibling: Pylon

var activated = false
var pylon_mat: ShaderMaterial

# Deactivate the pylon. If clear is set to false, the ID of the current pylon stored in Global will not clear
func deactivate(clear = true) -> void:
	activated = false
	if clear:
		Global.active_pylon = Global.ACTIVE_PYLON.duplicate()
	_update_pylon()

func disable() -> void:
	deactivate()
	bound = true
	_update_pylon(false)

# Don't try and set title text if in the editor 
func _set_title_text(get_text):
	if Engine.is_editor_hint(): return
	$Object/Title.set_text(get_text)

# Change the color of this pylon's unique material
func _shade_pylon(color: Color) -> void:
	pylon_mat.set_shader_parameter("color", color)

func _update_pylon(emit_enter_proximal = true) -> void:
	if pylon_type == PYLON_TYPE.START:
		_shade_pylon(debug_color * DIM)
	else: # destination pylons take their color from their starting sibling
		_shade_pylon(sibling.debug_color * DIM)
	if !bound:
		if pylon_type == PYLON_TYPE.START:
			if activated:
				_shade_pylon(debug_color)
				$Object.interact_string = "Deactivate"
			else: $Object.interact_string = "Activate"
		else:
			_set_title_text("[center]Pylon\n(Destination)[/center]")
			$Object.interact_string = "Bind"
	else:
		_set_title_text("[center]Pylon\n(Bound)[/center]")
		$Object.interact_string = "Teleport"
	
	if emit_enter_proximal and !Engine.is_editor_hint():
		Global.proximal_object.interact_string = $Object.interact_string

func _toggle_start_activation() -> void:
	if !activated:
		activated = true
		Global.active_pylon.id = pylon_id
		Global.active_pylon.position = global_position
		Global.pylon_start_activated.emit(pylon_id)
	else: deactivate()

func _ready() -> void:
	# Duplicate the material so that changing its color doesn't influence all other pylons
	var material = $PylonMesh/Pylon.get_active_material(0).duplicate()
	$PylonMesh/Pylon.set_surface_override_material(0, material)
	pylon_mat = $PylonMesh/Pylon.get_surface_override_material(0)
	
	$Object.id = pylon_id
	$Object.can_interact = true
	_update_pylon(false)
	
	if sibling == null: # disable if no sibling is attached
		$Object.can_interact = false
	
	if Engine.is_editor_hint(): return
	$Object.set_radius(1.0)
	Global.pylon_start_activated.connect(func(id):
		if !id == pylon_id:
			deactivate(false))

func _on_object_interacted() -> void:
	if bound:
		Global.move_player.emit(sibling.global_position + Vector3(-0.45, 0.1, 0))
	else:
		if pylon_type == PYLON_TYPE.START:
			_toggle_start_activation()
		else:
			bound = true
			sibling.disable()
	
	_update_pylon()
	Global.proximity_entered.emit()
