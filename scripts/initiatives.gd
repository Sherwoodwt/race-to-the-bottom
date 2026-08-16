class_name Initiatives
extends Node

@onready var start_initiatives: Array[InitiativeButton] = [$Scroll/Vbox/TestInitiative2, $Scroll/Vbox/TestInitiative3, $Scroll/Vbox/TestInitiative4, $Scroll/Vbox/TestInitiative5, $Vbox/TestInitiative6, $Vbox/TestInitiative7]

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
	SignalBus.alert.emit("Finished %s initiative on %s's team" % [initiative.title, employee.name])

func is_running() -> bool:
	for b in start_initiatives:
		if b.running:
			return true
	return false
