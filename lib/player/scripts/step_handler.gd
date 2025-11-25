extends RayCast3D

var current_walk_type := "none"

const walk_sounds := {
	"grass": preload("res://generic/sounds/step/step_grass.ogg"),
	"metal": preload("res://generic/sounds/step/step_metal.ogg")
}

func mute(state := true) -> void:
	if state:
		$StepSound.stop()
		$StepSound.volume_linear = 0.0
	else:
		$StepSound.play()
		$StepSound.volume_linear = 0.65

func change_walk_type() -> void:
	match current_walk_type:
		"none": $StepSound.stream = null
		_: $StepSound.stream = walk_sounds[current_walk_type]

func _ready() -> void:
	mute()

func _process(_delta: float) -> void:
	var _walk_type := "none"
	if get_collider():
		if "walk_type" in get_collider().get_meta_list():
			_walk_type = get_collider().get_meta("walk_type")
	
	if _walk_type != current_walk_type:
		current_walk_type = _walk_type
		change_walk_type()
