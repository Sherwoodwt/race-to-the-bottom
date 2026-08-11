extends Control

@onready var description: Label = $PanelContainer/VBoxContainer/Panel/MarginContainer/Label
@onready var okay_button: Button = $PanelContainer/VBoxContainer/Button2
@onready var close_button: Button = $Button

func _ready() -> void:
	okay_button.pressed.connect(hide_alert)
	close_button.pressed.connect(hide_alert)
	SignalBus.alert.connect(show_alert)

func show_alert(text: String):
	get_tree().paused = true
	description.text = text
	show()

func hide_alert():
	get_tree().paused = false
	hide()
