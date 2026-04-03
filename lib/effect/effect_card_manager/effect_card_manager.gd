extends HBoxContainer

var EffectCardScene := load("res://lib/effect/effect_card/effect_card.tscn")

@export var effect_manager: EffectManager:
	get: return(effect_manager)
	set(_effect_manager):
		deregister_effect_manager()
		effect_manager = _effect_manager
		on_effect_manager_change()

func deregister_effect_manager() -> void:
	if effect_manager:
		if effect_manager.effect_added.is_connected(on_effect_added):
			effect_manager.effect_added.disconnect(on_effect_added)

func on_effect_added(id: String) -> void:
	var effect := effect_manager.active_effects[id]
	var card: VBoxContainer = EffectCardScene.instantiate()
	card.effect_instance = effect
	add_child(card)

func on_effect_manager_change() -> void:
	# The effect manager has been cleared, and so all children need to be removed
	for _n: Node in get_children():
		_n.queue_free()
	
	if !effect_manager: return
	
	for _e in effect_manager.active_effects:
		var effect := effect_manager.active_effects[_e]
		var card: VBoxContainer = EffectCardScene.instantiate()
		card.effect_instance = effect
		add_child(card)
	
	# Otherwise there is a new effect manager, and its signals need to be connected
	effect_manager.effect_added.connect(on_effect_added)

func _ready() -> void:
	for _n: Node in get_children():
		_n.queue_free()
