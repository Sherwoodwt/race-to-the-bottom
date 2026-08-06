class_name PortraitButton
extends Button

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

var role: Role

func _ready():
	mouse_entered.connect(_handle_enter)

func _handle_enter():
	SignalBus.highlight.emit(self)

# used to modify existing button
func set_role(role: Role):
	self.role = role
	if role.employee:
		portrait.set_portrait(role.employee.portrait)
