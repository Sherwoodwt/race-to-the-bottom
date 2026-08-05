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
	set_focus(OrgData.top)
	SignalBus.focus_changed.connect(set_focus)

func set_focus(role: Role):
	clear_pressed(boss_button)
	clear_pressed(selected_button)
	clear_pressed(neighbor_right)
	clear_pressed(neighbor_left)
	for child in team.get_children():
		team.remove_child(child)
	
	if role.boss:
		boss_button.disabled = false
		boss_button.pressed.connect(func(): SignalBus.focus_changed.emit(role.boss))
		var prev = role.boss.find_neighbor(role, true)
		if prev:
			neighbor_left.disabled = false
			neighbor_left.pressed.connect(func(): SignalBus.focus_changed.emit(prev))
		else:
			neighbor_left.disabled = true
		var next = role.boss.find_neighbor(role)
		if next:
			neighbor_right.disabled = false
			neighbor_right.pressed.connect(func(): SignalBus.focus_changed.emit(next))
		else:
			neighbor_right.disabled = true
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
		button.profile = profile_modal

func clear_pressed(button: Button):
	for connection in button.pressed.get_connections():
		button.pressed.disconnect(connection.callable)


func _on_initiatives_pressed() -> void:
	SignalBus.initiative_pressed.emit(role.employee)


func _focus_boss() -> void:
	SignalBus.focus_changed.emit(role.boss)

func _focus_neighbor(left: bool):
	var index = role.boss.team.find(role)
	set_focus(index - 1 if left else index + 1)
