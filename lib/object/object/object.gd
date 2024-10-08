class_name DweltObject extends Node3D
# Object
# A generic interactable.

@export var id = "object"
@export var title = "((Object))"
@export_multiline var description = "((Object description.))"

@export var can_interact = false
@export var interact_string = "Interact"
@export var show_mote = false

signal interacted
var rng = RandomNumberGenerator.new()
var in_range = false
var distance_to_player: float

func set_radius(radius: float) -> void:
	$Range/Collision.shape.radius = radius

func _ready() -> void:
	$Title.set_text(title)
	$Anim.speed_scale = 0.5 + rng.randf() * 0.5
	$ObjectOrb.visible = show_mote
	
	# Check if the little button in the corner of the map has been pressed
	Global.interact_pressed.connect(func():
		if Global.proximal_object.id == id and Global.player_can_move:
			interacted.emit())

func _input(_event: InputEvent) -> void:
	# Interactions cannot occur if the player is in a locked state
	# (Prevents things like duplicate cutscenes)
	if !can_interact or !Global.player_can_move: return
	if Input.is_action_just_pressed("interact"):
		if Global.proximal_object.id == id:
			interacted.emit()

func _physics_process(_delta: float) -> void:
	distance_to_player = Global.player_position.distance_to(global_position)
	if distance_to_player < $Range/Collision.shape.radius:
		if !in_range: $EntrySound.play() # only do once
		in_range = true
	else:
		if in_range: $LeaveSound.play() # only do once
		in_range = false
