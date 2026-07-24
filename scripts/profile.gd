extends Control

@onready var employee_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var role_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Role
@onready var salary: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Salary
@onready var reliability: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Reliability
@onready var sociability: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Sociability
@onready var competency: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Competence
@onready var technical: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Intelligence

@export var demerit_scene: PackedScene

func _on_hierarchy_focus_changed(role: Role) -> void:
	employee_name.text = "Name: %s" % role.employee.name
	role_name.text = "Role: %s" % role.name
	salary.text = "Salary: $%s" % role.employee.salary
	reliability.text = attribute_text(role.employee.attributes.reliability)
	sociability.text = attribute_text(role.employee.attributes.sociability)
	competency.text = attribute_text(role.employee.attributes.competency)
	technical.text = attribute_text(role.employee.attributes.technical)

func attribute_text(val: int):
	var text = ""
	for i in range(val):
		text += "*"
	return text
