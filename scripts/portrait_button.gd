class_name PortraitButton
extends Button

const HOLD_TIME: int = 60

@onready var portrait: PortraitDisplay = $MarginContainer/Portrait

var role: Role

# used to modify existing button
func set_role(new_role: Role):
	self.role = new_role
	if new_role.employee:
		portrait.set_employee(new_role.employee)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e = event as InputEventMouseButton
		if e.is_released():
			if e.button_index == MouseButton.MOUSE_BUTTON_LEFT:
				SignalBus.highlight.emit(self)
			elif e.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
				SignalBus.focus_changed.emit(role)
		if e.double_click and e.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			SignalBus.focus_changed.emit(role)
