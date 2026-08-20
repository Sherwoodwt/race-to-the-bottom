class_name TaskButton
extends Button

@onready var timer: Timer = $Timer
@onready var progress: TextureProgressBar = $MarginContainer/HBoxContainer/TextureProgressBar
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var sprite: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var effect_label: Label = $MarginContainer/HBoxContainer/TextureProgressBar/HBoxContainer/Label2

@export var task: Task

var running: bool

func _ready():
	label.text = task.title
	sprite.texture = task.picture
	timer.wait_time = task.wait_time
	timer.timeout.connect(finish_task)
	pressed.connect(start_task)
	SignalBus.quarter_end.connect(reset)
	SignalBus.task_started.connect(check_disabled)
	check_disabled(task)

func _physics_process(_delta: float) -> void:
	if running:
		progress.value = 1.0 - timer.time_left / timer.wait_time

func start_task():
	timer.start()
	disabled = true
	running = true
	SignalBus.task_started.emit(task)

func finish_task():
	timer.stop()
	running = false
	progress.value = 0
	task.target.apply_task(task)
	SignalBus.task_finished.emit(task)
	SignalBus.alert.emit("Finished %s task on %s's team" % [task.title, task.employee.name])

func reset():
	disabled = false

func check_disabled(check_task: Task):
	if check_task.title == self.task.title:
		disabled = true

func check_employee(boss: Employee):
	var val: int = 0
	for employee in boss.role.worker_team():
		if employee.check_task(task):
			val += 1
	effect_label.text = "%d" % val
