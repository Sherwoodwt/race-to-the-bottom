class_name LoseScreen
extends Control

@onready var button: Button = $PanelContainer/VBoxContainer/Button
@onready var result_label: Label = $PanelContainer/VBoxContainer/Result

@export var menu: Control

func _ready():
	SignalBus.lose.connect(set_label)
	button.pressed.connect(to_main_menu)

func set_label(text: String):
	show()
	result_label.text = text

func to_main_menu():
	hide()
	menu.show()
