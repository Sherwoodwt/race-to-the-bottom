class_name Hierarchy
extends Control

@onready var boss_button: Button = $MarginContainer/VBoxContainer/UpButton
@onready var selected_button: PortraitButton = $MarginContainer/VBoxContainer/VBoxContainer/Selected
@onready var team: Control = $MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer2
@onready var name_tag: Label = $MarginContainer/VBoxContainer/VBoxContainer/NameTag

@export var role_scene: PackedScene

var role: Role

func _ready():
	boss_button.pressed.connect(_focus_boss)
	set_focus(OrgData.top)
	SignalBus.focus_changed.connect(set_focus)
	SignalBus.refresh_tree.connect(func(): set_focus(role))

func set_focus(target: Role):
	clear_pressed(selected_button)
	for child in team.get_children():
		team.remove_child(child)
	
	boss_button.disabled = target.boss == null
	
	selected_button.set_role(target)
	selected_button.pressed.connect(func(): SignalBus.highlight.emit(selected_button))
	self.role = target
	name_tag.text = target.employee.name
	
	for child in target.team:
		var button = role_scene.instantiate() as PortraitButton
		button.custom_minimum_size = Vector2(100, 100)
		button.pressed.connect(func(): SignalBus.highlight.emit(button))
		team.add_child(button)
		button.set_role(child)

func clear_pressed(button: Button):
	for connection in button.pressed.get_connections():
		button.pressed.disconnect(connection.callable)

func _on_initiatives_pressed() -> void:
	SignalBus.team_initiatives.emit(role.employee)

func _focus_boss() -> void:
	SignalBus.focus_changed.emit(role.boss)
