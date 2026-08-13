extends Control

@onready var next_button: Button = $PanelContainer/HBoxContainer/next_page
@onready var exit_button: Button = $PanelContainer/HBoxContainer/menu


func _ready():
	SignalBus.open_tutorial.connect(show)
	exit_button.pressed.connect(hide)
