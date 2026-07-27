extends Control

@onready var employee_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var role_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Role
@onready var salary: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Salary
@onready var productivity: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Productivity
@onready var reliability: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Reliability
@onready var sociability: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Sociability
@onready var competence: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Competence
@onready var technical: Label = $MarginContainer/VBoxContainer/HBoxContainer/AttributeVals/Intelligence
@onready var demerit_label: Label = $MarginContainer/VBoxContainer/Label
@onready var demerits: Control = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

@export var demerit_scene: PackedScene

func _ready():
	_on_hierarchy_focus_changed(OrgData.top)

func _on_hierarchy_focus_changed(role: Role) -> void:
	for child in demerits.get_children():
		demerits.remove_child(child)
	employee_name.text = "Name: %s" % role.employee.name
	role_name.text = "Role: %s" % role.name
	productivity.text = "Productivity: %d%%" % int(role.employee.get_productivity() * 100)
	
	if role == OrgData.top:
		salary.text = "This is you"
	else:
		salary.text = "Salary: $%s" % role.employee.salary
	reliability.text = Attributes.attribute_stars(role.employee.attributes.reliability)
	sociability.text = Attributes.attribute_stars(role.employee.attributes.sociability)
	competence.text = Attributes.attribute_stars(role.employee.attributes.competence)
	technical.text = Attributes.attribute_stars(role.employee.attributes.technical)
	for demerit in role.employee.demerits:
		var inst = demerit_scene.instantiate() as Label
		inst.text = demerit.text
		demerits.add_child(inst)
