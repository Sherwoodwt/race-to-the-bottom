extends Control

@onready var initiatives: InitiativeScreen = $PanelContainer/MarginContainer/VBoxContainer/Initiatives
@onready var organization_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Organization
@onready var initiatives_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Initiatives
@onready var notification: AudioStreamPlayer = $Notification

@export var lose_screen: PackedScene

func _ready():
	organization_tab.pressed.emit()
	SignalBus.team_initiatives.connect(_on_organization_team_initiatives)
	SignalBus.call_alert.connect(func(): notification.play())
	SignalBus.lose.connect(lose)

func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()

func lose(reason: String):
	var inst = lose_screen.instantiate() as LoseScreen
	add_sibling(inst)
	inst.set_label(reason)
	queue_free.call_deferred()
