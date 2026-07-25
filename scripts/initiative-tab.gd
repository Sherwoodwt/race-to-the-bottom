class_name InitiativeTab
extends Button

var running: bool

func _ready():
	SignalBus.initiative_complete.connect(check_finished)

func check_finished(initiative: Initiative):
	if 
