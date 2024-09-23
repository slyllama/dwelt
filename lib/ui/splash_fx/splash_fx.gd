extends CanvasLayer
# SplashFX
# Controls screen effects like pulsing in taking damage

func _ready() -> void:
	$Damage.self_modulate.a = 0.0
	Global.damage_taken.connect(func():
		$Anims.play("damage"))
