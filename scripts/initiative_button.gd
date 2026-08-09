class_name InitiativeButton
extends Button

signal started
signal ended

@onready var timer: Timer = $Timer
@onready var progress: TextureProgressBar = $MarginContainer/HBoxContainer/TextureProgressBar
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var description_label: Label = $MarginContainer/HBoxContainer/Label2
@onready var sprite: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var effect_label: Label = $MarginContainer/HBoxContainer/TextureProgressBar/HBoxContainer/Label2

@export var initiative: Initiative

var running: bool

func _ready():
	label.text = initiative.title
	description_label.text = initiative.description
	sprite.texture = initiative.picture
	timer.wait_time = initiative.wait_time
	timer.timeout.connect(finish_initiative)
	pressed.connect(start_initiative)
	SignalBus.quarter_end.connect(reset)
	SignalBus.initiative_started.connect(check_disabled)

func _physics_process(delta: float) -> void:
	if running:
		progress.value = 1.0 - timer.time_left / timer.wait_time

func start_initiative():
	timer.start()
	disabled = true
	running = true
	started.emit()

func finish_initiative():
	timer.stop()
	running = false
	progress.value = 0
	ended.emit()

func reset():
	disabled = false

func check_disabled(initiative: Initiative):
	if initiative.title == self.initiative.title:
		disabled = true

func check_employee(boss: Employee):
	var val: int = 0
	for employee in boss.role.worker_team():
		if employee.check_initiative(initiative):
			val += 1
	effect_label.text = "%d" % val
