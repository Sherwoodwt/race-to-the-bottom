class_name Organization
extends Control

signal team_initiatives(employee: Employee)




func _on_hierarchy_initiative_pressed(employee: Employee) -> void:
	team_initiatives.emit(employee)
