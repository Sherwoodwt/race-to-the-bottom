class_name Organization
extends Control

func _on_hierarchy_initiative_pressed(employee: Employee) -> void:
	SignalBus.team_initiatives.emit(employee)
