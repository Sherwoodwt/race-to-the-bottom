extends Control

signal focus_changed(role: Role)

@onready var boss_button: Button = $MarginContainer/HBoxContainer/Control/Boss
@onready var selected_button: Button = $MarginContainer/HBoxContainer/Control2/Selected
@onready var employees: Control = $MarginContainer/HBoxContainer/MarginContainer/ScrollContainer/Employees

@export var role_scene: PackedScene

func _ready():
	set_focus(OrgData.top)
	focus_changed.connect(set_focus)

func set_focus(role: Role):
	clear_pressed(boss_button)
	clear_pressed(selected_button)
	for child in employees.get_children():
		employees.remove_child(child)
	
	if role.boss:
		boss_button.visible = true
		boss_button.text = "%s\n%s" % [role.boss.name, role.boss.employee.name]
		boss_button.pressed.connect(func(): focus_changed.emit(role.boss))
	else:
		boss_button.visible = false
	
	selected_button.text = "%s\n%s" % [role.name, role.employee.name]
	selected_button.pressed.connect(func(): focus_changed.emit(role))
	
	for child in role.team:
		var button = role_scene.instantiate()
		if child.employee:
			button.text = "%s\n%s" % [child.name, child.employee.name]
			button.pressed.connect(func(): focus_changed.emit(child))
		else:
			button.disabled = true
		employees.add_child(button)

func clear_pressed(button: Button):
	for connection in button.pressed.get_connections():
		button.pressed.disconnect(connection.callable)
