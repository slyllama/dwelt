extends PanelContainer

func _ready() -> void:
	$Open.play()
	
	%ShardTitle.text = DwGlobal.current_shard.shard_name
	%DebugLabel.text = "Required Favour: " + str(DwGlobal.current_shard.required_favour)
