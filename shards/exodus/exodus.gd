extends Shard

func _ready() -> void:
	super()
	DwUtils.debug_sent.emit("/loadgadgets")
