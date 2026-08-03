extends Shard

func _ready() -> void:
	super()
	
	%TestGadget.effect_manager.add_effect(DwGadget.get_effect_data("test_effect"))
	%TestGadget.effect_manager.add_effect(DwGadget.get_effect_data("duration_effect"))
