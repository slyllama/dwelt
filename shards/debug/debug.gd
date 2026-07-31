extends Shard

func _ready() -> void:
	super()
	
	%TestGadget.effect_manager.add_effect(load("res://data/effects/test_effect.tres"))
