@icon("res://generic/icons/Projectile.svg")
class_name Projectile extends Area3D

const FIRE_ANIM_ID := "fire"

@export var cast_time := 3.0
@export var strips_resilience := true
@export var animation_player: AnimationPlayer
@export var free_on_animation_end := false # free after the "fire" animation has run

@onready var cast_timer := Timer.new()

signal just_fired

func is_player_colliding() -> bool:
	var _player_colliding := false
	var _colliders := get_overlapping_bodies()
	for _collider: PhysicsBody3D in _colliders:
		if _collider is DweltPlayer:
			_player_colliding = true
			break
	return(_player_colliding)

func _init() -> void:
	visible = false

func _ready() -> void:
	if animation_player:
		if free_on_animation_end:
			animation_player.animation_finished.connect(func(id: String) -> void:
				if id == FIRE_ANIM_ID:
					queue_free())
	
	cast_timer.wait_time = cast_time
	cast_timer.one_shot = true
	cast_timer.timeout.connect(func() -> void:
		just_fired.emit()
		Dwelt.shake_camera.emit()
		if animation_player:
			if FIRE_ANIM_ID in animation_player.get_animation_list():
				animation_player.play(FIRE_ANIM_ID)
		
		if is_player_colliding() and strips_resilience:
			Dwelt.player_effect_manager.decrement_effect_qty("resilience")
			Dwelt.player_effect_manager.cancel_effect("claiming")
		
		# Instantly free after fire if there is no firing animation (or animation player)
		if animation_player == null or !free_on_animation_end:
			queue_free()
	)
	
	add_child(cast_timer)
	cast_timer.start()
	
	await get_tree().process_frame
	visible = true
