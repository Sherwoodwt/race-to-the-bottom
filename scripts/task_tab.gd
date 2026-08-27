class_name TaskTab
extends Button

signal focused
signal closed

@onready var x_button: Button = $XButton
@onready var org_button: Button = $OrgButton

@export var x_button_sprite: Texture2D

var tasks: Tasks
var employee: Employee # set this

func _ready():
	x_button.pressed.connect(close)
	org_button.pressed.connect(func(): SignalBus.team_org.emit(employee))
	if employee.role == OrgData.top:
		x_button.visible = false
		x_button.disabled = false
	text = "%s's Team" % employee.name
	pressed.connect(focus_team)
	SignalBus.task_finished.connect(func(_i): check_running())
	SignalBus.fired.connect(func(e): if e == employee: queue_free.call_deferred())

func focus_team():
	x_button.visible = false
	for task in TaskData.tasks:
		task.check_employee(employee)
		if !task.running:
			task.task.target = employee
	disabled = true
	focused.emit()

func unfocus_team():
	disabled = false
	x_button.visible = true
	check_running()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and employee != OrgData.top.employee \
	and !disabled:
		queue_free.call_deferred()

func check_running():
	var running = tasks.running_count(employee)
	if running > 0:
		x_button.text = "%d" % running
		x_button.icon = null
	
	elif employee.role != OrgData.top:
		x_button.text = ""
		x_button.icon = x_button_sprite

func close():
	closed.emit()
	tasks.queue_free.call_deferred()
	queue_free.call_deferred()
