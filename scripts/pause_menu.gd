extends Control

@onready var return_button: Button = $Button
@onready var quit_button: Button = $Button2

func _ready():
	SignalBus.pause.connect(func(): show())
	SignalBus.unpause.connect(func(): hide())
	SignalBus.quit_to_menu.connect(func(): get_parent().queue_free.call_deferred(); get_tree().paused = false)
	return_button.pressed.connect(func(): SignalBus.unpause.emit())
	quit_button.pressed.connect(func(): SignalBus.quit_to_menu.emit())
