extends Gadget

func _ready() -> void:
	super()
	$Mineral/AnimationPlayer.play("idle")
