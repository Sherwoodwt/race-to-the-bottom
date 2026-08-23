class_name Tasks
extends Node

const DAY_BUFFER := 3

@onready var task_area: Control = $Scroll/MarginContainer/Vbox

@export var task_button_scene: PackedScene

var tasks: Array[TaskButton]
var employee: Employee

func _ready() -> void:
	SignalBus.task_timeout.connect(create_task)
	SignalBus.focus_changed.connect(func(e): employee = e)
	for c in task_area.get_children():
		task_area.remove_child(c)
	
	# generate first task at start
	create_task.call_deferred(90)
	var msg = "Your first task has been assigned.\n\n\nPlease view it on the Tasks tab at your earliest convenience."
	SignalBus.alert.emit.call_deferred(msg)

# return number of running tasks for employee
func running_count(employee: Employee) -> int:
	return tasks.filter(func(t: TaskButton): return t.running and t.task.target == employee).size()

func create_task(time_left: float):
	var task_type = TaskData.task_pool.pick_random()
	if task_type.min_wait_time > time_left + DAY_BUFFER:
		return # not enough time left in quarter
	var task = task_type.generate() as Task
	if task.wait_time > time_left + DAY_BUFFER:
		task.wait_time = time_left + DAY_BUFFER
	var task_button = task_button_scene.instantiate() as TaskButton
	task_button.task = task
	tasks.append(task_button)
	task_area.add_child(task_button)
	task_button.task.target = employee
	task_button.check_employee(employee)
