extends Node

const folder := "res://scripts/Initiatives/"

# are initiatives used up
# title -> bool
var used_initiatives: Dictionary

# current assigned initiatives
var initiative_pool: Array[Initiative]

func _ready() -> void:
	SignalBus.quarter_end.connect(reset)
	for file in ResourceLoader.list_directory(folder):
		var res := load(folder.path_join(file)) as Initiative
		used_initiatives[res.title] = false
	reset()

func reset():
	for i in used_initiatives.keys():
		used_initiatives[i] = false

func start_initiative(initiative: Initiative):
	used_initiatives[initiative.title] = true

func get_used_initiatives() -> Array[Initiative]:
	return used_initiatives.keys().filter(func(k): return used_initiatives[k])
