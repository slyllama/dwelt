extends Node3D
const RippleFX = preload("res://lib/object/ripple_fx/ripple_fx.tscn")

var idle = true

@onready var anims: Array[AnimationPlayer] = [
	get_node("SummonerModel/AnimationPlayer"),
	get_node("SummonerModel2/AnimationPlayer"),
	get_node("SummonerModel3/AnimationPlayer"),
	get_node("SummonerModel4/AnimationPlayer") ]

func activate() -> void:
	set_idle()
	idle = false
	
	for _a in anims:
		if !idle:
			_a.play("activate")
			await get_tree().create_timer(0.15).timeout

func set_idle() -> void:
	idle = true
	for _a in anims:
		_a.play("idle")

func _ready() -> void:
	anims[anims.size() - 1].animation_finished.connect(func(anim_name):
		if anim_name == "activate":
			await get_tree().create_timer(0.4).timeout
			var r = RippleFX.instantiate()
			r.position.y = 0.25
			add_child(r)
			for _a: AnimationPlayer in anims:
				_a.play("fire"))
	for _a in anims:
		_a.set_blend_time("idle", "activate", 0.19)
		_a.set_blend_time("fire", "idle", 0.5)
		set_idle()
