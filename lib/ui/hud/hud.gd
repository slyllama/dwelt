extends CanvasLayer
# HUD
# Handles and updates HUD elements; also collects some debug data

const SmokeTransition = preload("res://lib/ui/smoke_transition/smoke_transition.tscn")

# Replace text in-between '<' and '>' with colour
func _fmt_color_tags(input: String) -> String:
	var output = input.replace("<", "[color=yellow]")
	output = output.replace(">", "[/color]")
	return(output)

func _ready() -> void:
	# Establish visibilty
	$InteractSign.visible = false
	$Sidebar.visible = false
	
	var smoke_transition = SmokeTransition.instantiate()
	add_child(smoke_transition)
	
	Global.proximity_entered.connect(func():
		$Sidebar.visible = true
		$Sidebar/Heading/Title.text = Global.proximal_object.title
		$Sidebar/Info.text = _fmt_color_tags(Global.proximal_object.description)
		
		$InteractSign.text = "[center]" + Global.proximal_object.interact_string + "[/center]"
		if Global.proximal_object.can_interact: $InteractSign.visible = true
		else: $InteractSign.visible = false)
	
	Global.proximity_left.connect(func():
		$InteractSign.visible = false
		$Sidebar.visible = false)
