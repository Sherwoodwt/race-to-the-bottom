extends Control

@onready var return_button: Button = $MarginContainer/VBoxContainer/ReturnButton
@onready var tutorial_button: Button = $MarginContainer/VBoxContainer/TutorialButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

@export_group("Start Icon")
@export var start_button_texture: TextureRect
@export var start_icon: Texture2D
@export var pause_icon: Texture2D
@export_group("Return Button Icon")
@export var play_icon: Texture2D
@export var return_icon: Texture2D

var paused: bool

func _ready():
	SignalBus.pause.connect(func(): handle_pause(true))
	SignalBus.toggle_pause.connect(func(): handle_pause(!paused))
	SignalBus.quit_to_menu.connect(handle_quit)
	SignalBus.open_creator.connect(handle_start)
	return_button.pressed.connect(func(): SignalBus.open_creator.emit(); handle_pause(false))
	#quit_button.pressed.connect(func(): SignalBus.quit_to_menu.emit())
	quit_button.pressed.connect(func(): get_tree().quit())
	tutorial_button.pressed.connect(func(): SignalBus.open_tutorial.emit(); handle_pause(false))

func handle_pause(paused: bool):
	self.paused = paused
	visible = paused
	get_tree().paused = paused
	start_button_texture.texture = pause_icon if paused else start_icon

func handle_quit():
	for c in return_button.pressed.get_connections():
		return_button.pressed.disconnect(c["callable"])
	return_button.text = "NEW GAME"
	return_button.icon = play_icon
	return_button.pressed.connect(func(): SignalBus.open_creator.emit(); handle_pause(false))

func handle_start():
	for c in return_button.pressed.get_connections():
		return_button.pressed.disconnect(c["callable"])
	return_button.text = "RETURN"
	return_button.icon = return_icon
	return_button.pressed.connect(func(): handle_pause(false))

func _input(event: InputEvent) -> void:
	await get_tree().process_frame
	if paused:
		var e = event as InputEventMouseButton
		if e and e.pressed and not get_global_rect().has_point(get_global_mouse_position()):
			handle_pause(false)
	if Input.is_action_just_pressed("pause"):
		handle_pause(false)
