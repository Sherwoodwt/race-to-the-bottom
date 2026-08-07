extends Control

@onready var boss_button: Button = $MarginContainer/VBoxContainer/Control/UpButton
@onready var neighbor_left: Button = $MarginContainer/VBoxContainer/HBoxContainer/Control3/LeftButton
@onready var neighbor_right: Button = $MarginContainer/VBoxContainer/HBoxContainer/Control4/RightButton
@onready var selected_button: PortraitButton = $MarginContainer/VBoxContainer/HBoxContainer/Control2/Selected
@onready var team: Control = $MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer2

@export var role_scene: PackedScene
@export var profile_modal: ProfileModal

var role: Role

func _ready():
	boss_button.pressed.connect(_focus_boss)
	neighbor_left.pressed.connect(_focus_neighbor.bind(true))
	neighbor_right.pressed.connect(_focus_neighbor.bind(false))
	set_focus(OrgData.top)
	SignalBus.focus_changed.connect(set_focus)

func set_focus(role: Role):
	clear_pressed(selected_button)
	for child in team.get_children():
		team.remove_child(child)
	
	if role.boss:
		boss_button.disabled = false
		neighbor_left.disabled = !role.boss.find_neighbor(role, true)
		neighbor_right.disabled = !role.boss.find_neighbor(role)
	else:
		boss_button.disabled = true
		neighbor_right.disabled = true
		neighbor_left.disabled = true
	
	selected_button.disabled = true
	selected_button.set_role(role)
	self.role = role
	
	for child in role.team:
		var button = role_scene.instantiate() as PortraitButton
		if child.employee:
			button.pressed.connect(func(): SignalBus.focus_changed.emit(child))
		else:
			button.disabled = true
		if child.team.size() == 0:
			button.disabled = true
		team.add_child(button)
		button.set_role(child)

func clear_pressed(button: Button):
	for connection in button.pressed.get_connections():
		button.pressed.disconnect(connection.callable)


func _on_initiatives_pressed() -> void:
	SignalBus.team_initiatives.emit(role.employee)


func _focus_boss() -> void:
	SignalBus.focus_changed.emit(role.boss)

func _focus_neighbor(left: bool):
	var i = role.boss.team.find(role)
	if i >= 0 and i < role.boss.team.size():
		SignalBus.focus_changed.emit(role.boss.team[i-1] if left else role.boss.team[i+1])
