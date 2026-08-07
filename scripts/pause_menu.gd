extends Control

@onready var button: Button = $Button

func _ready():
	SignalBus.pause.connect(func(): show())
	SignalBus.unpause.connect(func(): hide())
	button.pressed.connect(func(): SignalBus.unpause.emit())
