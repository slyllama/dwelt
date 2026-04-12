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
	target_orb = $Orb.duplicate()
	target_orb.top_level = true
	add_child(target_orb)
	
	await get_tree().process_frame
	Dwelt.player_effect_manager.effect_added.connect(func(id: String) -> void:
		if id == "claiming":
			target = Dwelt.get_closest_gadget()
			await get_tree().process_frame
			$Orb.emitting = true
			target_orb.emitting = true
			update()
			await get_tree().create_timer(0.1).timeout
			$Beam.visible = true)
	
	Dwelt.player_effect_manager.effect_finished.connect(func(id: String) -> void:
		if id == "claiming": clear_beam())
	
	Dwelt.player_effect_manager.effect_cancelled.connect(func(id: String) -> void:
		if id == "claiming": clear_beam())

func _physics_process(_delta: float) -> void:
	if $Beam.visible: update()
