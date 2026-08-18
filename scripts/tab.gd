class_name Tab
extends Button

@export var tab_scene: Control

func _ready():
	pressed.connect(change_tab)

func change_tab():
	if not tab_scene.visible:
		tab_scene.show()
	tab_scene.move_to_front()
	button_pressed = true
