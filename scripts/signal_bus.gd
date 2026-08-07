extends Node

signal focus_changed(role: Role)
signal team_initiatives(employee: Employee)
signal highlight(target: PortraitButton)

signal initiative_finished(initiative: Initiative)
signal initiative_started(initiative: Initiative)

signal quarter_end
signal call_alert
signal lose(reason: String)
