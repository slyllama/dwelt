extends CanvasLayer
# UIPaneManager - handles ordering of panes, bringing panes to top, etc

var panes: Array[UIPane] = []

func update_z_index() -> void:
	for pane in panes:
		pane.z_index = panes.find(pane)
		Utils.pdebug(str(panes.find(pane)))

func _ready() -> void:
	for child in get_children():
		if child is UIPane:
			panes.append(child)
	update_z_index()
