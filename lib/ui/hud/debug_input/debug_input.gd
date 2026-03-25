extends PanelContainer
# DebugInput
# Used for inputting debug command and seeing their results
# TODO: output size limit

const INPUT_BUFFER_SIZE := 16
const OUTPUT_MAX_LINES := 7

var buffer: Array[String] = []
var buffer_pos := 0

func _release() -> void: # focus release and buffer reset shortcut
	buffer_pos = 0
	get_window().gui_release_focus()

func _eol() -> void: # go to end-of-line shortcut
	await get_tree().process_frame
	%Input.set_caret_column(999)

func send() -> void:
	var _o: String = %Input.text # output
	if _o == "": return # don't send an empty string
	# Only add the new command to the buffer if it is not the same
	# as the last-entered command
	var _u := true
	if buffer.size() > 0:
		if _o == buffer[0]: _u = false
		if _o == "/": _u = false # don't store an empty command
	if _u: buffer.push_front(_o)
	# Remove the oldest command if the buffer size is passed
	if buffer.size() > INPUT_BUFFER_SIZE:
		buffer.pop_back()
	Utils.debug_sent.emit(_o)
	%Input.text = ""
	_release()

func trim_output() -> void:
	var output_array: Array = %Output.text.split("\n")
	if output_array.size() > OUTPUT_MAX_LINES:
		while output_array.size() > OUTPUT_MAX_LINES:
			output_array.pop_front()
	%Output.text = ""
	for line: String in output_array:
		%Output.text += line + "\n"
	%Output.text = %Output.text.strip_edges(false, true)

func _ready() -> void:
	Utils.pdebug_sent.connect(func(string: String) -> void:
		%Output.text += "\n" + string
		trim_output())
	Utils.debug_sent.connect(func(string: String) -> void:
		if string == "/hello":
			Utils.pdebug("Hello, world!"))

func _input(_event: InputEvent) -> void:
	# Toggle input focusing
	if Input.is_action_just_pressed("debug_prefix"):
		%Input.grab_focus()
	elif Input.is_action_just_pressed("debug_input"):
		await get_tree().process_frame
		%Input.grab_focus()
	
	if Input.is_action_just_pressed("left_click"):
		if (%Input.has_focus()
			and !get_window().gui_get_hovered_control() is LineEdit):
			_release()
	
	if %Input.has_focus():
		# Handle browsing through old debug commands
		if Input.is_action_just_pressed("ui_up"):
			if buffer_pos < buffer.size():
				buffer_pos += 1
				%Input.text = buffer[buffer_pos - 1]
			_eol()
		elif Input.is_action_just_pressed("ui_down"):
			if buffer_pos > 1:
				buffer_pos -= 1
				%Input.text = buffer[buffer_pos - 1]
			_eol()
		
		# Handle sending debug commands (or cancelling input)
		elif Input.is_action_just_pressed("ui_accept"):
			send()
		elif Input.is_action_just_pressed("ui_cancel"):
			if %Input.text == "/": %Input.text = ""
			_release()
