class_name UIPaneManager extends CanvasLayer
# UIPaneManager - handles ordering of panes, bringing panes to top, etc

var panes: Array[UIPane] = []

# TODO: debug function only to test adding windows
func test_add_pane() -> void:
	var _uip: UIPane = load(
		"res://lib/ui/ui_pane/ui_pane.tscn").instantiate()
	_uip.title = "Test Pane"
	_uip.position = Vector2(24, 24)
	add_child(_uip)

# Registering a UI pane puts it in the drawing queue, ensuring that it gets
# moved to the front when clicked etc
func register_pane(pane: UIPane) -> void:
	panes.push_back(pane)
	pane.clicked.connect(func() -> void:
		put_on_top(pane))

# Panes must be closed through this method so they can be deregistered
func close_pane(pane: UIPane) -> void:
	panes.erase(pane)
	pane.close()

# Visually orders the node hierarchy of UIPanes according to their sorting
# in the array
func update_draw_order() -> void:
	for pane in panes:
		pane.move_to_front.call_deferred()

# Moves a UIPane to the end of the `panes` array, and then visually orders
# them using `update_draw_order()`
func put_on_top(pane: UIPane) -> void:
	if pane in panes:
		panes.erase(pane)
	panes.push_back(pane)
	update_draw_order()

func _ready() -> void:
	Dwelt.ui_pane_manager = self
	
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/testpane":
			Utils.pdebug("[color=yellow]Spawning test UIPane.[/color]", "UIPaneManager")
			test_add_pane())
	for child in get_children():
		if child is UIPane:
			register_pane(child)
	update_draw_order()

func _input(_event: InputEvent) -> void:
	# Close the top-most pane
	if Input.is_action_just_pressed("ui_cancel") and panes.size() > 0:
		var top_pane: UIPane = panes[panes.size() - 1]
		if top_pane.closeable:
			close_pane(top_pane)

func _on_child_entered_tree(node: Node) -> void:
	if node is UIPane:
		register_pane(node)
		update_draw_order()
