extends Node

@onready var options_button: Button = $Panel/Pause

func _ready():
	options_button.pressed.connect(func(): SignalBus.pause.emit())
