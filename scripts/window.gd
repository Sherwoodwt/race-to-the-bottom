extends PanelContainer

@export var tab: Tab

var close_button: Button

func _ready():
	# HACK to allowing clicking on non-focused windows to focus them
	propagate_call("set_mouse_filter", [MOUSE_FILTER_PASS])
	close_button = get_node_or_null("Control/Button")
	if close_button:
		close_button.pressed.connect(handle_hide)

func handle_hide():
	hide()

func _gui_input(event: InputEvent) -> void:
	var e = event as InputEventMouseButton
	if e and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		tab.pressed.emit()
