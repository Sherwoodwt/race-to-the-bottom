extends Node

signal focus_changed(role: Role)
signal highlight(target: PortraitButton)
signal team_initiatives(employee: Employee)
signal team_org(employee: Employee)
signal fired(employee: Employee)
signal refresh_tree

signal initiative_finished(initiative: Initiative)
signal initiative_started(initiative: Initiative)

signal quarter_end
signal call_alert
signal lose(reason: String)
signal pause
signal unpause
signal quit_to_menu
