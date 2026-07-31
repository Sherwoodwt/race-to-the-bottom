extends Control

signal focus_changed(role: Role)
signal initiative_pressed(employee: Employee)

@onready var boss_button: PortraitButton = $MarginContainer/VBoxContainer/Control/Boss
@onready var neighbor_left: PortraitButton = $MarginContainer/VBoxContainer/HBoxContainer/Control3/LeftNeighbor
@onready var neighbor_right: PortraitButton = $MarginContainer/VBoxContainer/HBoxContainer/Control4/RightNeighbor
@onready var selected_button: PortraitButton = $MarginContainer/VBoxContainer/HBoxContainer/Control2/Selected
@onready var team: Control = $MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer2
@export var role_scene: PackedScene

var role: Role

func _ready():
	set_focus(OrgData.top)
	focus_changed.connect(set_focus)

func set_focus(role: Role):
	clear_pressed(boss_button)
	clear_pressed(selected_button)
	clear_pressed(neighbor_right)
	clear_pressed(neighbor_left)
	for child in team.get_children():
		team.remove_child(child)
	
	if role.boss:
		boss_button.visible = true
		#boss_button.text = "%s\n%s" % [role.boss.name, role.boss.employee.name]
		boss_button.pressed.connect(func(): focus_changed.emit(role.boss))
		boss_button.set_role(role.boss)
		var prev = role.boss.find_neighbor(role, true)
		if prev:
			neighbor_left.visible = true
			#neighbor_left.text = "%s\n%s" % [prev.name, prev.employee.name]
			neighbor_left.pressed.connect(func(): focus_changed.emit(prev))
			neighbor_left.set_role(prev)
		else:
			neighbor_left.visible = false
		var next = role.boss.find_neighbor(role)
		if next:
			neighbor_right.visible = true
			#neighbor_right.text = "%s\n%s" % [next.name, next.employee.name]
			neighbor_right.pressed.connect(func(): focus_changed.emit(next))
			neighbor_right.set_role(next)
		else:
			neighbor_right.visible = false
	else:
		boss_button.visible = false
		neighbor_right.visible = false
		neighbor_left.visible = false
	
	#selected_button.text = "%s\n%s" % [role.name, role.employee.name]
	selected_button.disabled = true
	selected_button.set_role(role)
	self.role = role
	
	for child in role.team:
		var button = role_scene.instantiate() as PortraitButton
		if child.employee:
			#button.text = "%s\n%s" % [child.role.name, child.name]
			button.pressed.connect(func(): focus_changed.emit(child))
		else:
			button.disabled = true
		team.add_child(button)
		button.set_role(child)

func clear_pressed(button: PortraitButton):
	for connection in button.pressed.get_connections():
		button.pressed.disconnect(connection.callable)


func _on_initiatives_pressed() -> void:
	initiative_pressed.emit(role.employee)
