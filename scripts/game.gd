extends Control

@onready var initiatives: InitiativeScreen = $PanelContainer/MarginContainer/VBoxContainer/Initiatives
@onready var organization_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Organization
@onready var initiatives_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Initiatives

func _ready():
	organization_tab.pressed.emit()
	SignalBus.team_initiatives.connect(_on_organization_team_initiatives)


func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()
