class_name Organization
extends Control

@onready var hierarchy: Hierarchy = $Panel/MarginContainer/Hierarchy

func set_role(role: Role):
	hierarchy.set_focus(role)
