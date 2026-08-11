class_name PortraitButton
extends Button

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

var role: Role

func _ready():
	pressed.connect(handle_pressed)

# used to modify existing button
func set_role(role: Role):
	self.role = role
	if role.employee:
		portrait.set_employee(role.employee)

func handle_pressed():
	#if 
	SignalBus.highlight.emit(self)
