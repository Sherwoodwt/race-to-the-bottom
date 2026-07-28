extends Control

@onready var initiatives: InitiativeScreen = $Initiatives
@onready var organization_tab: Tab = $Tabs/Organization
@onready var initiatives_tab: Tab = $Tabs/Initiatives
@onready var assignments_tab: Tab = $Tabs/Assignment

func _ready():
	organization_tab.pressed.emit()


func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()
