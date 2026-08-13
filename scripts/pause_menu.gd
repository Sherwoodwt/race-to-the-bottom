extends Control

@onready var return_button: Button = $MarginContainer/VBoxContainer/Button2
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Button3

var paused: bool

func _ready():
	SignalBus.pause.connect(func(): handle_pause(true))
	SignalBus.toggle_pause.connect(func(): handle_pause(!paused))
	SignalBus.quit_to_menu.connect(func(): handle_pause(false))
	return_button.pressed.connect(func(): handle_pause(false))
	#quit_button.pressed.connect(func(): SignalBus.quit_to_menu.emit())
	quit_button.pressed.connect(func(): get_tree().quit())

func handle_pause(paused: bool):
	self.paused = paused
	visible = paused
	get_tree().paused = paused

func _input(event: InputEvent) -> void:
	await get_tree().process_frame
	if paused:
		var e = event as InputEventMouseButton
		if e and e.pressed and not get_global_rect().has_point(get_global_mouse_position()):
			handle_pause(false)
	if Input.is_action_just_pressed("pause"):
		handle_pause(false)
