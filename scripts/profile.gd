extends Control

signal initiative_selected(employee: Employee)

@onready var employee_name: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Name
@onready var role_name: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Role
@onready var salary: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Salary
@onready var productivity: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Productivity
@onready var reliability: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Reliability
@onready var sociability: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Sociability
@onready var competence: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Competence
@onready var technical: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Intelligence
@onready var demerits: Control = $MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/Demerits
@onready var initiative_button: Button = $MarginContainer/HBoxContainer/Buttons/InitiativesButton
@onready var fire_button: Button = $MarginContainer/HBoxContainer/Buttons/FireButton
@onready var portrait: PortraitDisplay = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Portrait

@export var demerit_scene: PackedScene

var employee: Employee

func _ready():
	_on_hierarchy_focus_changed(OrgData.top)

# only run on roles with employees
func _on_hierarchy_focus_changed(role: Role) -> void:
	employee = role.employee
	portrait.set_portrait(employee.portrait)
	for child in demerits.get_children():
		demerits.remove_child(child)
	initiative_button.disabled = OrgData.top == role or role.team.size() == 0
	fire_button.disabled = OrgData.top == role \
		or role.employee.demerits.size() == 0 \
		or role.boss.team.size() == 1
	employee_name.text = role.employee.name
	if role == OrgData.top:
		employee_name.text += " (YOU)"
	role_name.text = role.name
	productivity.text = "%d%%" % int(role.employee.get_productivity() * 100)
	
	salary.text = "$%s" % role.employee.salary
	reliability.text = Attributes.attribute_stars(role.employee.attributes.reliability)
	sociability.text = Attributes.attribute_stars(role.employee.attributes.sociability)
	competence.text = Attributes.attribute_stars(role.employee.attributes.competence)
	technical.text = Attributes.attribute_stars(role.employee.attributes.technical)
	for demerit in role.employee.demerits:
		var inst = demerit_scene.instantiate() as Label
		inst.text = demerit.text
		demerits.add_child(inst)


func _on_initiatives_button_pressed() -> void:
	initiative_selected.emit(employee)


func _on_fire_button_pressed() -> void:
	employee.fire()
