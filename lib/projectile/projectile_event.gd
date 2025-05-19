class_name ProjectileEvent extends Node3D

func play(data: Dictionary) -> void:
	if !"type" in data: # fail if important information is missing
		print("[ProjectileEvent] Event data is missing type.")
		queue_free()
	match data.type:
		"test":
			print("[ProjectileEvent] test!")

func _ready() -> void:
	pass
