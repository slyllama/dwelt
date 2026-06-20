extends Node2D

func _on_anim_animation_finished(_anim_name: StringName) -> void:
	queue_free()
