class_name Organization
extends Control

signal team_initiatives(employee: Employee)

@onready var review_section: Control = $Panel/MarginContainer/VBoxContainer/Panel/Reviews
@onready var demerits: Control = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Profile/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/Demerits

func _on_hierarchy_initiative_pressed(employee: Employee) -> void:
	team_initiatives.emit(employee)


func _on_hierarchy_focus_changed(role: Role) -> void:
	if role == OrgData.top:
		review_section.visible = false
		demerits.visible = false
	else:
		review_section.visible = true
		demerits.visible = true
