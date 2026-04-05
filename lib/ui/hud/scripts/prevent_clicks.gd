extends ColorRect
# PreventClicks
# Prevent clicks registering around panning events

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	Dwelt.camera_pan_started.connect(func() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP)
	
	Dwelt.camera_pan_ended.connect(%CDTimer.start)

func _on_cd_timer_timeout() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
