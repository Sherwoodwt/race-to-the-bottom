class_name Game
extends Control

@onready var initiatives: InitiativeScreen = $PanelContainer/MarginContainer/VBoxContainer/Initiatives
@onready var organization_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Organization
@onready var initiatives_tab: Tab = $PanelContainer/MarginContainer/VBoxContainer/Tabs/Initiatives
@onready var notification: AudioStreamPlayer = $Notification
@onready var pause_menu: Control = $PauseMenu

func _ready():
	organization_tab.pressed.emit()
	SignalBus.team_initiatives.connect(_on_organization_team_initiatives)
	SignalBus.call_alert.connect(func(): notification.play())
	SignalBus.lose.connect(lose)
	SignalBus.pause.connect(_handle_pause.bind(true))
	SignalBus.unpause.connect(_handle_pause.bind(false))
	pause_menu.hide()

func _on_organization_team_initiatives(employee: Employee) -> void:
	initiatives.add_team(employee)
	initiatives_tab.change_tab()

func lose(reason: String):
	queue_free.call_deferred()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		SignalBus.pause.emit()

func _handle_pause(paused: bool):
	pause_menu.visible = !get_tree().paused
	get_tree().paused = !get_tree().paused
