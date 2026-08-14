class_name ProfileModal
extends Control

@onready var close_button: Button = $Control/Button

var portrait: PortraitButton

func _ready():
	SignalBus.highlight.connect(set_employee)
	close_button.pressed.connect(hide)

func set_employee(target: PortraitButton):
	portrait = target
	show()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.is_pressed():
		if not get_global_rect().has_point(get_global_mouse_position()):
			hide()
