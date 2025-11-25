extends "res://lib/shard/shard.gd"

func _ready() -> void:
	$Player.queue_free()
	$HUD/MenuBar.disappear()
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	$Orbit.rotation.y += Utils.crit_plerp(0.25)
