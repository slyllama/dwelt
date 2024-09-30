extends "res://lib/ui/ui_container/ui_container.gd"
# Settings

func _ready():
	super()
	$Container/FOV.value = SettingsHandler.settings.fov
	
	SettingsHandler.setting_changed.connect(func(parameter):
		match parameter:
			"fov":
				$Container/FOVTitle.text = "Field of view: " + str(SettingsHandler.settings.fov) + "deg"
				$Container/FOV.value = SettingsHandler.settings.fov
	)

# Open with a hotkey
func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("settings"):
		if !is_open: open()
		else: close()

func _physics_process(_delta: float) -> void:
	# Display some more debug data, because we can
	$Container/PlayerPos.text = "(" + Utilities.fmt_vec3(Global.player_position) + ")"
	$Container/PlayerPos.text += " " + str(snapped(rad_to_deg(CameraData.facing_angle), 1)) + "deg"

func _on_fov_value_changed(value: float) -> void:
	SettingsHandler.update("fov", value)
