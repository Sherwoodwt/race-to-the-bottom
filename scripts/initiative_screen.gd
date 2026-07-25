class_name InitiativeScreen
extends Control

@onready var tab_area: Control = $Panel/MarginContainer/VBoxContainer/HBoxContainer

@export var initiative_tab_scene: PackedScene

var tabs: Array[InitiativeTab]

func _ready():
	# add first one org wide
	var inst = initiative_tab_scene.instantiate() as InitiativeTab
	inst.employee = OrgData.top.employee
	inst.focused.connect(func(): team_focused(inst))
	tab_area.add_child(inst)
	inst.text = "Org-Wide"
	tabs.append(inst)
	inst.focus_team()

func add_team(employee: Employee):
	var index = tabs.find_custom(func(t): return t.employee == employee)
	if index >= 0:
		tabs[index].focus_team()
		return
	
	var inst = initiative_tab_scene.instantiate() as InitiativeTab
	inst.employee = employee
	inst.focused.connect(func(): team_focused(inst))
	tab_area.add_child(inst)
	tabs.append(inst)
	inst.focus_team()

func team_focused(tab: InitiativeTab):
	for t in tabs:
		if t != tab:
			t.unfocus_team()
