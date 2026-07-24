class_name Tab
extends Button

signal tab_changed

@export var tab_scene: Control

var tab: Control

func _ready():
	pressed.connect(change_tab)
	var tabs = get_parent().get_children().filter(func (c): return c is Tab and c != self)
	for t in tabs:
		t.tab_changed.connect(hide_tab)

func change_tab():
	tab.visible = true
	tab_changed.emit()

func hide_tab():
	tab.visible = false
 
