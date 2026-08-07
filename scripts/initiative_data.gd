extends Node

const folder := "res://scripts/Initiatives/"

# initiative -> bool
var used_initiatives: Dictionary

func _ready() -> void:
	SignalBus.quarter_end.connect(reset)
	for file in DirAccess.get_files_at(folder):
		var res := load(folder.path_join(file)) as Initiative
		used_initiatives[res.title] = false
	reset()

func reset():
	for i in used_initiatives.keys():
		used_initiatives[i] = false

func start_initiative(initiative: Initiative):
	used_initiatives[initiative.title] = true
