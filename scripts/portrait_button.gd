class_name PortraitButton
extends Node

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

var _role: Role

func set_role(role: Role):
	_role = role
	if role.employee:
		portrait.set_portrait(role.employee.portrait)
