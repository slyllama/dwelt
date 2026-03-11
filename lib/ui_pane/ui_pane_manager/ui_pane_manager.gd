extends CanvasLayer
# UIPaneManager - handles ordering of panes, bringing panes to top, etc

var panes: Array[UIPane] = []

func update_draw_order() -> void:
	for pane in panes:
		pane.move_to_front.call_deferred()

func put_on_top(pane: UIPane) -> void:
	if pane in panes:
		panes.erase(pane)
	panes.push_back(pane)
	update_draw_order()

func _ready() -> void:
	for child in get_children():
		if child is UIPane:
			panes.append(child)
			child.clicked.connect(func() -> void:
				put_on_top(child))
	update_draw_order()

# TODO: needs testing
func _on_child_entered_tree(node: Node) -> void:
	if node is UIPane:
		panes.push_back(node)
		update_draw_order()
