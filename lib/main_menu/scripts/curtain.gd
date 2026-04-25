extends ColorRect

const CURTAIN_TRANS_DURATION := 0.35
signal trans_finished

func trans_in() -> void:
	self.modulate.a = 0.0
	self.visible = true
	var _t := create_tween()
	_t.tween_property(self, "modulate:a", 1.0, CURTAIN_TRANS_DURATION)
	_t.tween_callback(func() -> void:
		trans_finished.emit())

func trans_out() -> void:
	self.modulate.a = 1.0
	self.visible = true
	var _t := create_tween()
	_t.tween_property(self, "modulate:a", 0.0, CURTAIN_TRANS_DURATION)
	_t.tween_callback(func() -> void:
		self.visible = false
		trans_finished.emit())
