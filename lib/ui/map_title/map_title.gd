extends Control
# MapTitle
# Pretty title that displays when the player enters a map

func _ready() -> void:
	$MapTitle/TextBloom.material.set_shader_parameter("size", 0.0)
	modulate.a = 0.0
	
	await get_tree().create_timer(1.0).timeout
	$MapTitle.text = "[center]" + str(Global.target_scene_title) + "[/center]"
	$AnimateTitle.play("play")


func _on_animate_title_animation_finished(anim_name: StringName) -> void:
	if anim_name == "play":
		queue_free()
