@tool
extends TextureRect

@export var flip_frame := false:
	set(_flip_frame):
		flip_frame = _flip_frame
		flip_h = flip_frame
@export var effect_particles_playing := false:
	set(_effect_particles_playing):
		effect_particles_playing = _effect_particles_playing
		$FXParticles.emitting = effect_particles_playing

func _ready() -> void:
	$FXParticles.emitting = effect_particles_playing
