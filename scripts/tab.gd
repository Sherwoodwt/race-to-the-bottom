class_name Tab
extends Button

signal tab_changed

@export var tab_scene: Control

func _ready():
	pressed.connect(change_tab)
	var tabs = get_parent().get_children().filter(func (c): return c is Tab and c != self)
	# maybe use this for setting to not focus
	# TODO This is where I'm leaving off
	for t in tabs:
		t.tab_changed.connect(hide_tab)

func change_tab():
	tab_scene.visible = true
	tab_scene.z_index = 10
	tab_changed.emit()

func hide_tab():
	#tab_scene.visible = false
	tab_scene.z_index = maxi(tab_scene.z_index - 1, 0)
