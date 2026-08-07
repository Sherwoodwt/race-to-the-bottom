class_name Profile
extends Control

@onready var employee_name: Label = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Name
@onready var role_name: Label = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Role
@onready var salary: Label = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Salary
@onready var productivity: Label = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Productivity
@onready var reliability: Label = $VBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Reliability
@onready var sociability: Label = $VBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Sociability
@onready var competence: Label = $VBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Competence
@onready var technical: Label = $VBoxContainer/VBoxContainer/HBoxContainer/AttributeVals/Intelligence
@onready var demerits: Control = $VBoxContainer/VBoxContainer/ScrollContainer/Demerits
@onready var initiative_button: Button = $VBoxContainer/HBoxContainer/InitiativesButton
@onready var fire_button: Button = $VBoxContainer/HBoxContainer/FireButton
@onready var portrait: PortraitDisplay = $VBoxContainer/VBoxContainer/HBoxContainer/Portrait

@export var demerit_scene: PackedScene

var employee: Employee

func _ready():
	SignalBus.highlight.connect(_on_hierarchy_focus_changed)
	initiative_button.pressed.connect(func(): SignalBus.team_initiatives.emit(employee))
	fire_button.pressed.connect(func(): employee.fire())

func _on_hierarchy_focus_changed(target: PortraitButton) -> void:
	var role = target.role
	if not role.employee:
		return
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
	
	salary.text = "$%sK" % role.employee.salary
	reliability.text = Attributes.attribute_stars(role.employee.attributes.reliability)
	sociability.text = Attributes.attribute_stars(role.employee.attributes.sociability)
	competence.text = Attributes.attribute_stars(role.employee.attributes.competence)
	technical.text = Attributes.attribute_stars(role.employee.attributes.technical)
	for demerit in role.employee.demerits:
		var inst = demerit_scene.instantiate() as Label
		inst.text = demerit.text
		demerits.add_child(inst)
