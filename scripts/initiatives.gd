class_name Initiatives
extends Node

@onready var start_initiatives: Array[InitiativeButton] = [$TestInitiative2, $TestInitiative3, $TestInitiative4, $TestInitiative5, $TestInitiative6, $TestInitiative7]

var employee: Employee

func _ready() -> void:
	for i in start_initiatives:
		i.started.connect(func(): handle_start(i.initiative))
		i.ended.connect(func(): handle_finish(i.initiative))

func handle_start(initiative: Initiative):
	SignalBus.initiative_started.emit(initiative)
	InitiativeData.start_initiative(initiative)

func handle_finish(initiative: Initiative):
	employee.apply_initiative(initiative)
	SignalBus.initiative_finished.emit(initiative)

func is_running() -> bool:
	for b in start_initiatives:
		if b.running:
			return true
	return false
