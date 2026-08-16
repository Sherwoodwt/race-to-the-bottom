class_name Game
extends Control

@onready var initiatives: InitiativeScreen = $PanelContainer3/MarginContainer/Initiatives
@onready var organization: Organization = $PanelContainer2/MarginContainer/Organization
@onready var call_tab: Tab = $Tabs/Call
@onready var organization_tab: Tab = $Tabs/Organization
@onready var initiatives_tab: Tab = $Tabs/Initiatives
@onready var notification: AudioStreamPlayer = $Notification

func _ready():
	call_tab.pressed.emit()
	SignalBus.team_initiatives.connect(_on_organization_team_initiatives)
	SignalBus.team_org.connect(_on_team_org)
	SignalBus.call_alert.connect(func(): notification.play())
	SignalBus.lose.connect(lose)

func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()

func _on_team_org(employee: Employee) -> void:
	organization.set_role(employee.role)
	organization_tab.change_tab()

func lose(reason: String):
	queue_free.call_deferred()
