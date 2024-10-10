class_name DweltObject extends Node3D
# Object
# A generic interactable.

@export var id = "object"
@export var title = "((Object))"
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
	use_hold_circle = state
	if can_interact:
		$Title/HoldCircle.visible = state
	# If interaction is disabled the hold circle won't even show
	else: $Title/HoldCircle.visible = false

func set_radius(radius: float) -> void:
	$Range/Collision.shape.radius = radius

func _ready() -> void:
	$Title.set_text(title)
	$Anim.speed_scale = 0.5 + rng.randf() * 0.5
	$ObjectOrb.visible = show_mote
	set_use_hold_circle(use_hold_circle)
	
	# Check if the little button in the corner of the map has been pressed
	Global.interact_pressed.connect(func():
		if (Global.proximal_object.id == id and Global.player_can_move):
			if !use_hold_circle: # use _on_hold_circle_completed
				interacted.emit())

func _input(_event: InputEvent) -> void:
	# Interactions cannot occur if the player is in a locked state
	# (Prevents things like duplicate cutscenes). Interactions will also
	# not trigger here if the object is using a hold circle
	if !can_interact or !Global.player_can_move: return
	if Input.is_action_just_pressed("interact"):
		if Global.proximal_object.id == id:
			if !use_hold_circle:
				interacted.emit()

func _process(_delta: float) -> void:
	if $Title/HoldCircle.visible:
		$Title/HoldCircle.global_position = $Title.track_position + Vector2(0, 50.0)

func _physics_process(_delta: float) -> void:
	distance_to_player = Global.player_position.distance_to(global_position)
	if distance_to_player < $Range/Collision.shape.radius:
		if !in_range: $EntrySound.play() # only do once
		in_range = true
		if use_hold_circle:
			$Title/HoldCircle.visible = true
	else:
		if in_range: $LeaveSound.play() # only do once
		in_range = false
		if use_hold_circle:
			$Title/HoldCircle.visible = false

func _on_hold_circle_completed() -> void:
	if !can_interact or !Global.player_can_move: return
	if Global.proximal_object.id == id:
		interacted.emit()
