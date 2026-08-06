class_name ProfileModal
extends Control

var portrait: PortraitButton

func _ready():
	SignalBus.highlight.connect(set_employee)

func set_employee(target: PortraitButton):
	portrait = target
	var rect := get_rect()
	var bounds := get_parent_area_size()
	var displacement := portrait.size / 1.5
	global_position.x = portrait.global_position.x + displacement.x
	global_position.y = portrait.global_position.y - rect.size.y + displacement.y
	show()

func _input(event: InputEvent) -> void:
	if not visible or event is not InputEventMouseMotion:
		return
	var mouse := get_global_mouse_position()
	var on_modal := get_global_rect().has_point(mouse)
	var on_portrait := portrait.get_global_rect().has_point(mouse)
	if not on_modal and not on_portrait:
		hide()
