extends Node3D

@export var floor_disabled := true
@export var respawn_height_limit := -4.0

func _ready() -> void:
	if floor_disabled == true: $DebugFloor.set_collision_layer_value(1, false)
	else: $DebugFloor.set_collision_layer_value(1, true)

var _c = 0

func _physics_process(_delta: float) -> void:
	_c += 1
	if _c >= 3: _c = 0
	else: return # don't run every frame
	
	# Recover the player if they get below a certain height
	if $Player.position.y < respawn_height_limit:
		$Player.position = $SpawnPoint.position
