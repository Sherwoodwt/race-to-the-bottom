extends Control

@onready var return_button: Button = $Button
@onready var quit_button: Button = $Button2

func _ready():
	SignalBus.pause.connect(func(): handle_pause(true))
	SignalBus.unpause.connect(func(): handle_pause(false))
	SignalBus.quit_to_menu.connect(func(): get_parent().queue_free.call_deferred(); handle_pause(false))
	return_button.pressed.connect(func(): SignalBus.unpause.emit())
	quit_button.pressed.connect(func(): SignalBus.quit_to_menu.emit())

func handle_pause(paused: bool):
	visible = paused
	get_tree().paused = paused
