class_name Initiatives
extends Node

@onready var start_initiatives: Array[Initiative] = [$TestInitiative2, $TestInitiative3, $TestInitiative4, $TestInitiative5, $TestInitiative6, $TestInitiative7]

var employee: Employee

# Initiative -> has run this quarter: bool
var initiatives: Dictionary

func _ready() -> void:
	for i in start_initiatives:
		initiatives[i] = false
		i.started.connect(handle_start.bind(i))
		i.ended.connect(handle_finish.bind(i))
	SignalBus.quarter_end.connect(reset_initiatives)

func handle_start(initiative: Initiative):
	SignalBus.initiative_started.emit(initiative)
	initiatives[initiative] = true

func handle_finish(initiative: Initiative):
	employee.roll_for_demerit(initiative)
	SignalBus.initiative_finished.emit(initiative)

func reset_initiatives():
	for i in initiatives.keys():
		initiatives[i] = false
	for i in start_initiatives:
		i.disabled = false
