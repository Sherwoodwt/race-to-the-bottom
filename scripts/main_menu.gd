extends Control

@onready var start_button: Button = $Start
@onready var exit_button: Button = $Exit

@export var game_scene: PackedScene

func _ready():
	start_button.pressed.connect(start)
	exit_button.pressed.connect(exit)
	SignalBus.quit_to_menu.connect(show)

func start():
	var inst = game_scene.instantiate()
	InitiativeData.reset()
	OrgData.reset(OrgData.top)
	add_sibling(inst)
	hide()
	
func exit():
	get_tree().quit()
