@tool
class_name Gadget extends Area3D
# Gadget
# A gadget is a passive item which can trigger an event when the player is
# in its proximity

signal interacted

@export var title = "((Gadget))":
	get: return(title)
	set(_val):
		title = _val
		$SpatialText.text = title
@export var radius = 1.0:
	get: return(radius)
	set(_val):
		radius = _val
		$Collision.shape.radius = radius
@export var interact_text = "Interact"
@export var dismiss_interaction = true

func _interact() -> void:
	Reporter.do_shake_camera.emit()
	interacted.emit()
	
	if dismiss_interaction:
		Reporter.current_gadget = null
		Reporter.gadget_changed.emit()

func _input(_event: InputEvent) -> void:
	if Reporter.current_gadget != self: return
	if Input.is_action_just_pressed("interact"):
		_interact()

func _on_body_entered(body: Node3D) -> void:
	if body is DweltPlayer:
		Reporter.current_gadget = self
		Reporter.gadget_changed.emit()

func _on_body_exited(body: Node3D) -> void:
	if body is DweltPlayer and Reporter.current_gadget == self:
		Reporter.current_gadget = null
		Reporter.gadget_changed.emit()
