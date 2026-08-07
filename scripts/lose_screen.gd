class_name LoseScreen
extends Node

@onready var button: Button = $Button
@onready var result_label: Label = $Result

@export var menu: PackedScene

func _ready():
	button.pressed.connect(to_main_menu)

func set_label(text: String):
	result_label.text = text

func to_main_menu():
	var inst = menu.instantiate()
	add_sibling(inst)
	queue_free.call_deferred()
