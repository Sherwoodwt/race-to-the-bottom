extends PanelContainer

@onready var close_button: Button = $"MarginContainer2/Button"

func _ready():
	if close_button:
		close_button.pressed.connect(hide)

func _input():
	if 
