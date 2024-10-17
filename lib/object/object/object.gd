@tool
class_name DweltObject extends Node3D
# Object
# A generic interactable.

@export var id = "object"
@export var title = "((Object))"
@export var radius = 1.7:
	set(_value):
		radius = _value
		set_radius(_value)
	get:
		return(radius)
@export_multiline var description = "((Object description.))"
@export var show_mote = false

@export_category("Interaction")
@export var can_interact = false
@export var use_hold_circle = false
@export var interact_string = "Interact"

signal interacted
var rng = RandomNumberGenerator.new()
var in_range = false
var distance_to_player: float

# TODO: properly toggle interaction (i.e., trigger proximity left)

func set_use_hold_circle(state):
	if can_interact:
		$Title/HoldCircle.visible = state
		use_hold_circle = state
	# If interaction is disabled the hold circle won't even show
	else: $Title/HoldCircle.visible = false

# unique_shape prevents this from affecting all objects
func set_radius(get_radius: float) -> void:
	var _unique_shape = $Range/Collision.shape.duplicate()
	$Range/Collision.shape = _unique_shape
	$Range/Collision.shape.radius = get_radius

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	$Title.set_text(title)
	$Anim.speed_scale = 0.5 + rng.randf() * 0.5
	$ObjectOrb.visible = show_mote
	$Stars.emitting = false
	set_use_hold_circle(use_hold_circle)
	
	# Check if the diamond in map corner has been pressed...
	Global.interact_pressed.connect(func():
		if (Global.proximal_object.id == id and Global.player_can_move):
			if use_hold_circle: $Title/HoldCircle.spin()
			else: interacted.emit())
	# ...or held, if using a hold circle
	Global.interact_released.connect(func():
		if (Global.proximal_object.id == id and Global.player_can_move):
			if use_hold_circle:
				$Title/HoldCircle.stop())

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	# Interactions cannot occur if the player is in a locked state
	# (Prevents things like duplicate cutscenes). Interactions will also
	# not trigger here if the object is using a hold circle
	if !can_interact or !Global.player_can_move: return
	if Input.is_action_just_pressed("interact"):
		if Global.proximal_object.id == id:
			if !use_hold_circle:
				interacted.emit()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if $Title/HoldCircle.visible:
		$Title/HoldCircle.global_position = $Title.track_position + Vector2(0, 100.0)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	distance_to_player = Global.player_position.distance_to(global_position)
	if distance_to_player < $Range/Collision.shape.radius:
		if !in_range: $EntrySound.play() # only do once
		in_range = true
		$Stars.emitting = true
		if use_hold_circle: $Title/HoldCircle.visible = true
	else:
		if in_range: $LeaveSound.play() # only do once
		in_range = false
		$Stars.emitting = false
		if use_hold_circle: $Title/HoldCircle.visible = false

func _on_hold_circle_completed() -> void:
	if !can_interact or !Global.player_can_move: return
	if Global.proximal_object.id == id:
		interacted.emit()
