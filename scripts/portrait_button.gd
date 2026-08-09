class_name PortraitButton
extends Button

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

@export var link_only: bool

var role: Role

func _ready():
	if not link_only:
		mouse_entered.connect(_handle_enter)
	else:
		pressed.connect(func(): SignalBus.focus_changed.emit(role))

func _handle_enter():
	SignalBus.highlight.emit(self)

# used to modify existing button
func set_role(role: Role):
	self.role = role
	if role.employee:
		portrait.set_employee(role.employee)
