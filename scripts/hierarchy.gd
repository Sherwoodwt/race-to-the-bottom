extends Control

signal focus_changed(role: Role)
signal initiative_pressed(employee: Employee)

@onready var boss_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Boss
@onready var neighbor_up: Button = $MarginContainer/HBoxContainer/VBoxContainer/NeighborUp
@onready var neighbor_down: Button = $MarginContainer/HBoxContainer/VBoxContainer/NeighborDown
@onready var selected_button: Button = $MarginContainer/HBoxContainer/Control2/Selected
@onready var initiative_button: Button = $MarginContainer/HBoxContainer/Control2/Initiatives
@onready var employees: Control = $MarginContainer/HBoxContainer/MarginContainer/ScrollContainer/Employees
@export var role_scene: PackedScene

var role: Role

func _ready():
	set_focus(OrgData.top)
	focus_changed.connect(set_focus)

func set_focus(role: Role):
	clear_pressed(boss_button)
	clear_pressed(selected_button)
	clear_pressed(neighbor_down)
	clear_pressed(neighbor_up)
	for child in employees.get_children():
		employees.remove_child(child)
	
	if role.boss:
		boss_button.visible = true
		boss_button.text = "%s\n%s" % [role.boss.name, role.boss.employee.name]
		boss_button.pressed.connect(func(): focus_changed.emit(role.boss))
		var prev = role.boss.find_neighbor(role, true)
		if prev:
			neighbor_up.visible = true
			neighbor_up.text = "%s\n%s" % [prev.name, prev.employee.name]
			neighbor_up.pressed.connect(func(): focus_changed.emit(prev))
		else:
			neighbor_up.visible = false
		var next = role.boss.find_neighbor(role)
		if next:
			neighbor_down.visible = true
			neighbor_down.text = "%s\n%s" % [next.name, next.employee.name]
			neighbor_down.pressed.connect(func(): focus_changed.emit(next))
		else:
			neighbor_down.visible = false
	else:
		boss_button.visible = false
		neighbor_down.visible = false
		neighbor_up.visible = false
	
	selected_button.text = "%s\n%s" % [role.name, role.employee.name]
	selected_button.disabled = true
	self.role = role
	initiative_button.disabled = role.team.size() == 0
	#selected_button.pressed.connect(func(): focus_changed.emit(role))
	
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


func _on_initiatives_pressed() -> void:
	initiative_pressed.emit(role.employee)
