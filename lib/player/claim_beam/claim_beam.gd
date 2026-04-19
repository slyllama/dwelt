extends Node3D

@export var target: Node3D

var target_orb: GPUParticles3D

func update() -> void:
	if target and target_orb:
		target_orb.global_position = target.global_position
		target_orb.global_position.y += 1.0
		
		$Orb.global_position = global_position
		$Beam.look_at(target_orb.global_position)
		$Beam.rotation_degrees.x += 90.0
		$Beam.global_position = (target_orb.global_position + $Orb.global_position) / 2.0
		
		var _length: float = $Orb.global_position.distance_to(target_orb.global_position)
		$Beam.scale.y = _length

func clear_beam() -> void:
	$Orb.emitting = false
	target_orb.emitting = false
	$Beam.visible = false

func _ready() -> void:
	$Orb.emitting = false
	
	target_orb = $Orb.duplicate()
	target_orb.top_level = true
	add_child(target_orb)
	
	await get_tree().process_frame
	Dwelt.player_effect_manager.effect_added.connect(func(id: String) -> void:
		if id == "claiming":
			$Beam.visible = false
			
			target = Dwelt.selected_gadget
			target_orb.emitting = true
			$Orb.emitting = true
			$Claim.play()
			Dwelt.shake_camera.emit()
			Utils.debug_sent.emit("/playvoice") # TODO: this should be more formalized
			
			update()
			$Beam.visible = true)
	
	Dwelt.player_effect_manager.effect_finished.connect(func(id: String) -> void:
		if id == "claiming":
			Dwelt.shake_camera.emit()
			clear_beam())
	
	Dwelt.player_effect_manager.effect_cancelled.connect(func(id: String) -> void:
		if id == "claiming":
			Dwelt.shake_camera.emit()
			$Claim.stop()
			$ClaimFail.play()
			clear_beam())

func _physics_process(_delta: float) -> void:
	if $Orb.emitting: update()

func _on_visible_delay_timeout() -> void:
	$Beam.visible = true
