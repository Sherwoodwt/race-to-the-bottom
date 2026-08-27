extends Node

const MAX_TEAM_SIZE = 10
const MIN_TEAM_SIZE = 6 # just initial
const MAX_REHIRE_AMOUNT := 4

@onready var leadership_roles: Array[Role] = load_all("res://scripts/Roles/leadership/")
@onready var worker_roles: Array[Role] = load_all("res://scripts/Roles/workers/")

var top: Role
var fired_employees: Array[Employee]

func load_all(path: String):
	var roles: Array[Role]
	var files = ResourceLoader.list_directory(path)
	for file in files:
		var instance = load(path.path_join(file)) as Role
		roles.append(instance)
	return roles

func _ready():
	SignalBus.new_quarter.connect(new_quarter)
	SignalBus.fired.connect(handle_fired)
	top = make_tree(0)
	make_comments(top)

func reset(role: Role):
	role.employee.reset_demerits()
	role.employee.productivity_changed.emit()
	for r in role.team:
		reset(r)

func make_tree(level: int) -> Role:
	var cur: Role
	if level < leadership_roles.size():
		cur = leadership_roles[level].duplicate(true)
		var team_size = randi_range(MIN_TEAM_SIZE, MAX_TEAM_SIZE)
		for i in range(team_size):
			var child = make_tree(level + 1)
			child.boss = cur
			cur.team.append(child)
	else:
		cur = worker_roles.pick_random().duplicate(true)
	if level != 0:
		cur.employee = Employee.generate(cur)
		cur.employee.productivity_changed.connect(func(): SignalBus.productivity_changed.emit())
	else:
		cur.employee = Employee.generate(cur)
		cur.employee.attributes.reliability = 5
		cur.employee.attributes.sociability = 5
		cur.employee.attributes.competence = 5
		cur.employee.attributes.technical = 5
	return cur

# mutates hierarchy to add reviews
func make_comments(role: Role):
	if role != top:
		role.employee.generate_reviews()
	for child in role.team:
		make_comments(child)

func get_total_budget() -> int:
	return top.employee.get_budget()

func new_quarter():
	reset(top)
	var sorted_managers := top.manager_team()
	sorted_managers.sort_custom(func(a, b): return a.role.team.size() < b.role.team.size())
	for i in randi_range(0, MAX_REHIRE_AMOUNT):
		var smallest = sorted_managers.pop_front()
		if smallest != null and smallest.role.team.size() < MAX_TEAM_SIZE:
			var newb := worker_roles.pick_random().duplicate(true) as Role
			newb.employee = Employee.generate(newb)
			newb.employee.productivity_changed.connect(func(): SignalBus.productivity_changed.emit())
			smallest.role.team.append(newb)
			newb.employee.generate_reviews(true)
	SignalBus.refresh_tree.emit()

func handle_fired(employee: Employee):
	fired_employees.append(employee)
	# apply changes to acquaintances
	for review in employee.reviews:
		if review.stars >= 3:
			var demerit = Demerit.new()
			demerit.value = (review.stars - 2) * .1
			demerit.text = "Someone they like was fired"
			review.author.demerits.append(demerit)
	# promote next person and adjust hierarchy recursively
	handle_replacement(employee.role)
	SignalBus.refresh_tree.emit()
	SignalBus.productivity_changed.emit()

# promote subordinate up, or if no subordinates just remove from hierarchy
func handle_replacement(role: Role):
	if role.team.size() == 0:
		role.boss.team.remove_at(role.boss.team.find(role))
		return
	
	var promotee: Role
	for r in role.team:
		if not promotee or r.employee.salary > promotee.employee.salary:
			promotee = r
	role.employee = promotee.employee
	promotee.employee.role = role
	SignalBus.alert.emit("%s promoted to %s" % [promotee.employee.name, role.name])
	handle_replacement(promotee)
