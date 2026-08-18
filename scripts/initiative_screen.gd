class_name InitiativeScreen
extends Control

@onready var tab_area: Control = $Panel/MarginContainer/VBoxContainer/ScrollContainer/Panel/MarginContainer/HBoxContainer
@onready var initiative_area: Control = $Panel/MarginContainer/VBoxContainer/Panel/MarginContainer/InitiativeArea

@export var initiative_tab_scene: PackedScene

var tabs: Array[InitiativeTab]

func _ready():
	# add first one org wide
	var inst = initiative_tab_scene.instantiate() as InitiativeTab
	inst.initiative_area = initiative_area
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
	# TODO: add something here after adding initiatives, this is to create the initiatives on a new
	# tab for a selected team, but doesn't work because there's no reference and I'm not adding it because
	# it'll be refactored anyway.
	#inst.initiatives = 
	inst.employee = employee
	inst.focused.connect(func(): team_focused(inst))
	tab_area.add_child(inst)
	tabs.append(inst)
	inst.closed.connect(func(): tabs.remove_at(tabs.find_custom(func(t): return t.employee == inst.employee)))
	inst.focus_team()

func team_focused(tab: InitiativeTab):
	for t in tabs:
		if t != tab:
			t.unfocus_team()
