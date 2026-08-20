class_name Game
extends Control

@onready var tasks: TaskScreen = $TasksWindow/MarginContainer/Tasks
@onready var organization: Organization = $OrgChartWindow/MarginContainer/Organization
@onready var call_tab: Tab = $Tabs/Call
@onready var organization_tab: Tab = $Tabs/Organization
@onready var tasks_tab: Tab = $Tabs/Tasks
@onready var profile_tab: Tab = $Tabs/Profile
@onready var notification_sound: AudioStreamPlayer = $Notification

func _ready():
	call_tab.button_pressed = true
	SignalBus.team_tasks.connect(_on_organization_team_tasks)
	SignalBus.highlight.connect(func(_p): profile_tab.change_tab())
	SignalBus.team_org.connect(_on_team_org)
	SignalBus.call_alert.connect(func(): notification_sound.play())
	SignalBus.lose.connect(lose)

func _on_organization_team_tasks(employee: Employee) -> void:
	tasks.add_team(employee)
	tasks_tab.change_tab()

func _on_team_org(employee: Employee) -> void:
	organization.set_role(employee.role)
	organization_tab.change_tab()

func lose(_reason: String):
	queue_free.call_deferred()
