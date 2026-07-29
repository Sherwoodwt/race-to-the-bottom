class_name InitiativeTab
extends Button

signal focused

@onready var initiative_area: Control = $"../../InitiativeArea"

@export var initiatives_scene: PackedScene
@export var employee: Employee # set this

var initiatives: Initiatives
var running: bool

func _ready():
	text = "%s's Team" % employee.name
	initiatives = initiatives_scene.instantiate() as Initiatives
	initiative_area.add_child(initiatives)
	initiatives.employee = employee
	initiatives.started.connect(func(): running = true)
	initiatives.finished.connect(func(): running = false)
	initiatives.visible = false
	pressed.connect(focus_team)

func focus_team():
	initiatives.visible = true
	for initiative in initiatives.start_initiatives:
		initiative.check_employee(employee)
	disabled = true
	focused.emit()

func unfocus_team():
	initiatives.visible = false
	disabled = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and employee != OrgData.top.employee \
	and !disabled:
		queue_free.call_deferred()
