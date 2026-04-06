extends CanvasLayer
# Override canvas sits on top of everything else. Mainly used for playing
# flashing effects

const Flash = preload("res://lib/ui/hud/flash/flash.tscn")

func _ready() -> void:
	Dwelt.play_flash.connect(func(flash_position: Vector2) -> void:
		var _f := Flash.instantiate()
		_f.global_position = flash_position
		add_child(_f))
