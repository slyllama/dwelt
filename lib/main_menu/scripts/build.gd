extends Label
# Display the current build number

func _ready() -> void:
	text = "Build " + str(ProjectSettings.get_setting("application/config/version"))
