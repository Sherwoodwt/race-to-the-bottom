class_name TaskTab
extends Button

signal focused
signal closed

@onready var x_button: Button = $XButton
@onready var org_button: Button = $OrgButton

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
	SignalBus.task_finished.connect(func(_i): check_closable())
	SignalBus.fired.connect(func(e): if e == employee: queue_free.call_deferred())

func focus_team():
	x_button.visible = false
	for task in tasks.tasks:
		task.check_employee(employee)
	disabled = true
	focused.emit()

func unfocus_team():
	disabled = false
	check_closable()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and employee != OrgData.top.employee \
	and !disabled:
		queue_free.call_deferred()

func check_closable():
	if !tasks.visible and employee.role != OrgData.top:
		if not tasks.is_running():
			x_button.visible = true

func close():
	closed.emit()
	tasks.queue_free.call_deferred()
	queue_free.call_deferred()
