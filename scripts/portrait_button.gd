class_name PortraitButton
extends Button

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

@export var profile: ProfileModal
var _role: Role

func set_role(role: Role):
	_role = role
	if role.employee:
		portrait.set_portrait(role.employee.portrait)

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	var mouse = get_global_mouse_position()
	var rect = get_global_rect().has_point(mouse)
	#var modal = profile.visible and profile.get_global_rect().has_point(mouse)
	var overlap = rect
	if overlap:
		profile.set_employee(_role.employee)
		profile.show()
	elif profile.visible and !overlap:
		profile.hide()
