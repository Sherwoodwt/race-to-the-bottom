extends Control

@onready var start_button: Button = $PanelContainer/HBoxContainer/next_page
@onready var exit_button: Button = $PanelContainer/HBoxContainer/menu

@export var creator: Control

func _ready():
	start_button.pressed.connect(start)
	exit_button.pressed.connect(exit)
	SignalBus.quit_to_menu.connect(show)

func start():
	creator.show()
	hide()
	
func exit():
	get_tree().quit()
