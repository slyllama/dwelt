class_name ProximityArea extends Area3D
# Used for detecting when the player gets in interacting range of a gadget
# WARNING: this must only be the child of a gadget, or it will be freed with
# an error displayed

@export var radius := 2.4
@onready var proximity_collision := CollisionShape3D.new()

func _ready() -> void:
	input_ray_pickable = false
	
	# If this node is not the child of a gadget, destroy it
	if !get_parent() is Gadget:
		Utils.pdebug("Error: attached to a parent which isn't a gadget.", "ProximityArea")
		return
	
	var proximity_shape := SphereShape3D.new()
	proximity_shape.radius = radius
	proximity_collision.shape = proximity_shape
	add_child(proximity_collision)
	
	body_entered.connect(func(body: Node3D) -> void:
		if body is DweltPlayer:
			Dwelt.gadgets_close_to_player.append(get_parent())
			Dwelt.gadgets_close_to_player_changed.emit())
	
	body_exited.connect(func(body: Node3D) -> void:
		if body is DweltPlayer and get_parent() in Dwelt.gadgets_close_to_player:
			Dwelt.gadgets_close_to_player.erase(get_parent())
			Dwelt.gadgets_close_to_player_changed.emit())
