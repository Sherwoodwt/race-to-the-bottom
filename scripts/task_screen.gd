class_name TaskScreen
extends Control

@onready var tab_area: Control = $Panel/MarginContainer/VBoxContainer/ScrollContainer/Panel/MarginContainer/HBoxContainer
@onready var tasks: Tasks = $Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/TaskArea/Tasks

@export var task_tab_scene: PackedScene

var tabs: Array[TaskTab]

func _ready():
	# add first one org wide
	var inst = task_tab_scene.instantiate() as TaskTab
	inst.tasks = tasks
	inst.employee = OrgData.top.employee
	inst.tasks.employee = inst.employee
	inst.focused.connect(func(): team_focused(inst))
	tab_area.add_child(inst)
	inst.focus_team()
	inst.text = "Org-Wide"
	tabs.append(inst)

func add_team(employee: Employee):
	var index = tabs.find_custom(func(t): return t.employee == employee)
	if index >= 0:
		tabs[index].focus_team()
		return
	
	var inst = task_tab_scene.instantiate() as TaskTab
	inst.tasks = tasks
	inst.employee = employee
	inst.focused.connect(func(): team_focused(inst))
	tab_area.add_child(inst)
	tabs.append(inst)
	inst.closed.connect(func(): tabs.remove_at(tabs.find_custom(func(t): return t.employee == inst.employee)))
	inst.focus_team()

func team_focused(tab: TaskTab):
	for t in tabs:
		if t != tab:
			t.unfocus_team()
	for t in tasks.tasks:
		t.visible = !t.running or t.task.target == tab.employee
