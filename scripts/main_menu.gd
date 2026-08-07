extends Control

@onready var start_button: Button = $Start
@onready var exit_button: Button = $Exit

@export var game: PackedScene

func _ready():
	start_button.pressed.connect(start)
	exit_button.pressed.connect(exit)

func start():
	var inst = game.instantiate()
	add_sibling(inst)
	queue_free.call_deferred()
	
func exit():
	get_tree().quit()
