@tool
extends Gadget

func _on_ready() -> void:
	$Lantern/AnimationPlayer.play("idle")

func _physics_process(_delta: float) -> void:
	$Orb.global_position = $Lantern/Armature/Skeleton3D/Orb_2.global_position
