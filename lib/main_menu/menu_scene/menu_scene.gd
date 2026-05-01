extends Node3D

const CLAMP := 0.05
var target_z_position := 0.0 # used for zooming on shard load

@onready var base_position: Vector3 = %Pivot.global_position
@onready var target_position: Vector3 = base_position

func _ready() -> void:
	%LightAnim.play("flicker")
	await %LightAnim.animation_finished
	%LightAnim.play("glow")

func _physics_process(_delta: float) -> void:
	var _m := (get_window().get_mouse_position() # mouse delta to center
		- get_window().size / get_window().content_scale_factor / 2.0)
	
	var _dm := Vector2(_m.x * -0.0001, _m.y * 0.0001)
	_dm.x = clamp(_dm.x, -CLAMP, CLAMP)
	_dm.y = clamp(_dm.y, -CLAMP, CLAMP)
	target_position = base_position + Vector3(_dm.x, _dm.y, target_z_position)
	%Pivot.global_position = lerp(%Pivot.global_position, target_position, Utils.crit_plerp(2.0))
