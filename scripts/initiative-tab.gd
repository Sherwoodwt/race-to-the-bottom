class_name InitiativeTab
extends Button

signal focused
signal closed

@onready var initiative_area: Control = $"../../../InitiativeArea"
@onready var x_button: Button = $XButton
@onready var org_button: Button = $OrgButton

@export var initiatives_scene: PackedScene
@export var employee: Employee # set this

var initiatives: Initiatives

func _ready():
	x_button.pressed.connect(close)
	org_button.pressed.connect(func(): SignalBus.team_org.emit(employee))
	if employee.role == OrgData.top:
		x_button.visible = false
		x_button.disabled = false
	text = "%s's Team" % employee.name
	initiatives = initiatives_scene.instantiate() as Initiatives
	initiative_area.add_child(initiatives)
	initiatives.employee = employee
	initiatives.visible = false
	pressed.connect(focus_team)
	SignalBus.initiative_finished.connect(func(_i): check_closable())
	SignalBus.fired.connect(func(e): if e == employee: queue_free.call_deferred())

func focus_team():
	x_button.visible = false
	initiatives.visible = true
	for initiative in initiatives.start_initiatives:
		initiative.check_employee(employee)
	disabled = true
	focused.emit()

func unfocus_team():
	initiatives.visible = false
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
	if !initiatives.visible and employee.role != OrgData.top:
		if not initiatives.is_running():
			x_button.visible = true

func close():
	closed.emit()
	initiatives.queue_free.call_deferred()
	queue_free.call_deferred()
