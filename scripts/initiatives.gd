class_name Initiatives
extends Node

signal started
signal finished

@onready var start_initiatives: Array[Initiative] = [$TestInitiative2, $TestInitiative3, $TestInitiative4, $TestInitiative5, $TestInitiative6, $TestInitiative7]

var employee: Employee

# Initiative -> running: bool
var initiatives: Dictionary

func _ready() -> void:
	for i in start_initiatives:
		initiatives[i] = false
		i.initiative_started.connect(handle_start)
		i.initiative_finished.connect(handle_finish)

func handle_start(initiative: Initiative):
	if !is_running(): # none running yet
		started.emit()
	initiatives[initiative] = true

func handle_finish(initiative: Initiative):
	employee.roll_for_demerit(initiative)
	initiatives[initiative] = false
	if !is_running(): # all done
		finished.emit()

func is_running():
	var running = false
	for initiative in initiatives.keys():
		running = running and initiatives[initiative]
	return running
