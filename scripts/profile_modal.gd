class_name ProfileModal
extends Control

var portrait: PortraitButton

func _ready():
	SignalBus.highlight.connect(set_employee)

func set_employee(target: PortraitButton):
	portrait = target
	var rect := get_global_rect()
	var bounds := get_parent_control().get_global_rect()
	var displacement := portrait.size / 1.5
	global_position.x = portrait.global_position.x + portrait.size.x
	global_position.y = portrait.global_position.y - rect.size.y + displacement.y
	# reset rect to updated position
	rect = get_global_rect()
	if not bounds.encloses(rect):
		# flip x displacement if past half way
		if rect.position.x + rect.size.x > bounds.position.x + (bounds.size.x / 2.0):
			global_position.x = portrait.global_position.x - rect.size.x
		# just clamp y
		global_position.y = clampf(global_position.y, bounds.position.y, bounds.position.y + bounds.size.y - rect.size.y)
	show()

func _input(event: InputEvent) -> void:
	if not visible or event is not InputEventMouseMotion:
		return
	var mouse := get_global_mouse_position()
	var on_modal := get_global_rect().has_point(mouse)
	var on_portrait := portrait.get_global_rect().has_point(mouse)
	if not on_modal and not on_portrait:
		hide()
