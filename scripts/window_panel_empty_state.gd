class_name WindowPanelEmptyState
extends WindowPanel

@export var empty: Control
@export var not_empty: Control
@export var toggle_signal: String

func _ready():
	super()
	empty.show()
	not_empty.hide()
	SignalBus.connect(toggle_signal, toggle)

func toggle(...args):
	not_empty.show()
	empty.hide()
