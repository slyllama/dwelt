class_name Shard extends Node3D

@export var shard_data: ShardData
@export var floor_disabled := true
@export var respawn_height_limit := -4.0

func _ready() -> void:
	Utils.set_vol(0.0)
	
	if shard_data:
		Utils.pdebug("Entered shard '" + shard_data.shard_id + "'.", "Shard")
	else: Utils.pdebug("Missing metadata!", "Shard")
	
	if floor_disabled == true: $DebugFloor.set_collision_layer_value(1, false)
	else: $DebugFloor.set_collision_layer_value(1, true)
	
	await get_tree().process_frame
	var _t = create_tween()
	_t.tween_method(Utils.set_vol, 0.0, 1.0, 2.0)

var _c = 0

func _physics_process(_delta: float) -> void:
	if !get_node_or_null("Player"): return
	_c += 1
	if _c >= 3: _c = 0
	else: return # don't run every frame
	
	# Recover the player if they get below a certain height
	if $Player.position.y < respawn_height_limit:
		$Player.position = $SpawnPoint.position
