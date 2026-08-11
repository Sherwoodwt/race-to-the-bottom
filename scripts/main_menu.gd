extends Control

@onready var start_button: Button = $Start
@onready var exit_button: Button = $Exit
@onready var creator: Control = $"../CharacterCreator"

func _ready():
	start_button.pressed.connect(start)
	exit_button.pressed.connect(exit)
	SignalBus.quit_to_menu.connect(show)

func start():
	creator.show()
	hide()
	
func exit():
	get_tree().quit()
