extends Control

@onready var initiative_area: Control = $Initiatives/Panel/MarginContainer/InitiativeArea

@export var initiative_tab_scene: PackedScene

var team_tabs: Dictionary # { employee: tab}

func add_team(employee: Employee):
	if team_tabs.has(employee):
		(team_tabs[employee] as Button).pressed.emit()
		return
	
	var inst = initiative_tab_scene.instantiate() as Button
	inst.text = "%s's Team" % employee.name
	inst.pressed.connect(func(): focus_team(employee))
	initiative_area.add_child(inst)
	initiative_area.move_child(inst, 0)
	team_tabs[employee] = inst

func focus_team(employee: Employee):
	var tab = team_tabs[employee]
	tab.disabled = true
	for t in team_tabs.keys().filter(func(k): return k != employee):
		t.disabled = false
