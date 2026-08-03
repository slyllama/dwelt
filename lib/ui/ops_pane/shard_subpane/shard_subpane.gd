extends PanelContainer

func _ready() -> void:
	$Open.play()
	
	$DebugLabel.text = "Required Favour: " + str(DwGlobal.current_shard.required_favour)
