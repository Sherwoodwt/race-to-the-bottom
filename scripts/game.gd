extends Control

@onready var initiatives: InitiativeScreen = $Initiatives
@onready var organization_tab: Tab = $Tabs/Organization
@onready var initiatives_tab: Tab = $Tabs/Initiatives
@onready var timer: Timer = $Q_Timer

func _ready():
	timer.timeout.connect(end_quarter)
	timer.start()
	organization_tab.pressed.emit()

func end_quarter():
	print("Quarter is over")
	# TODO: Pop up here with status
	timer.start()


func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()
