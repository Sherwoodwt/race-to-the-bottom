extends Node

signal productivity_changed

const MAX_TEAM_SIZE = 10
const MIN_TEAM_SIZE = 6 # just initial
const PRODUCTIVITY_MIN := .5

@onready var leadership_roles: Array[Role] = load_all("res://scripts/Roles/leadership/")
@onready var worker_roles: Array[Role] = load_all("res://scripts/Roles/workers/")

var top: Role
var fired_employees: Array[Employee]

func load_all(path: String):
	var roles: Array[Role]
	var files = DirAccess.get_files_at(path)
	for file in files:
		var instance = load(path.path_join(file)) as Role
		roles.append(instance)
	return roles

func _ready():
	SignalBus.quarter_end.connect(func(): reset(top))
	SignalBus.fired.connect(handle_fired)
	top = make_tree(0)
	make_comments(top)

func reset(role: Role):
	role.employee.demerits.clear()
	role.employee.get_productivity()
	role.employee.productivity_changed.emit()
	for r in role.team:
		reset(r)

func make_tree(level: int) -> Role:
	var top: Role
	if level < leadership_roles.size():
		top = leadership_roles[level].duplicate(true)
		var team_size = randi_range(MIN_TEAM_SIZE, MAX_TEAM_SIZE)
		for i in range(team_size):
			var child = make_tree(level + 1)
			child.boss = top
			top.team.append(child)
	else:
		# TODO: pick a certain amount of each
		top = worker_roles.pick_random().duplicate(true)
	if level != 0:
		top.employee = Employee.generate(top)
		top.employee.productivity_changed.connect(func(): productivity_changed.emit())
	else:
		top.employee = Employee.generate(top)
		top.employee.attributes.reliability = 5
		top.employee.attributes.sociability = 5
		top.employee.attributes.competence = 5
		top.employee.attributes.technical = 5
	return top

# mutates hierarchy to add reviews
func make_comments(role: Role):
	role.employee.generate_reviews()
	for child in role.team:
		make_comments(child)

func get_total_budget() -> int:
	return top.employee.get_budget()

func handle_fired(employee: Employee):
	employee.role.employee = null
	fired_employees.append(self)
	# promote next person
	handle_promotions(employee.role)

func handle_promotions(role: Role):
	if role.team.size() == 0:
		return
	var promotee: Role
	for r in role.team:
		if not promotee or r.employee.salary > promotee.employee.salary:
			promotee = r
	role.employee = promotee.employee
	promotee.employee = null
	if promotee.team.size() > 0:
		handle_promotions(promotee)
