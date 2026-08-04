class_name ProfileModal
extends Control

@onready var profile: Profile = $ProfileDetails/Profile

func set_employee(employee: Employee):
	profile.employee = employee
	profile._on_hierarchy_focus_changed(employee.role)
