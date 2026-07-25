class_name Initiatives
extends Node

signal all_done

@export var initiatives: Array[Initiative]

func _ready() -> void:
	for i in initiatives:
		i.initiative_finished.connect(handle_finished)

func handle_finished(initiative: Initiative):
	pass
