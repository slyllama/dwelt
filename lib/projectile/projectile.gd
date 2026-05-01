class_name Projectile extends Area3D

func _ready() -> void:
	body_entered.connect(func(body: PhysicsBody3D) -> void:
		if body is DweltPlayer:
			Dwelt.player_effect_manager.decrement_effect_qty("resilience")
			print("owie"))
