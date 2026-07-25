class_name Employee
extends Resource

@export var name: String
@export var role: Role
@export var salary: int
@export var attributes: Attributes
@export var demerits: Array[Demerit]
@export var reviews: Array[Review]

static func generate(role: Role) -> Employee:
	var employee = Employee.new()
	employee.name = NameGenerator.random_name()
	employee.role = role
	employee.salary = randf_range(role.salary_range.x, role.salary_range.y)
	employee.attributes = Attributes.make_comperable(role.attributes)
	employee.role = role
	return employee

func roll_for_demerit(initiative: Initiative):
	if role.team.size() == 0:
		var ini = initiative.attributes
		var rel = randf_range(0, ini.reliability) > attributes.reliability
		var soc = randf_range(0, ini.sociability) > attributes.sociability
		var com = randf_range(0, ini.competence) > attributes.competence
		var tec = randf_range(0, ini.technical) > attributes.technical
		if rel or soc or com or tec:
			demerits.append(initiative.demerit.duplicate())
	else:
		for member in role.team:
			member.employee.roll_for_demerit(initiative)

func get_productivity():
	var results = [
		attributes.reliability - role.attributes.reliability,
		attributes.sociability - role.attributes.sociability,
		attributes.competence - role.attributes.competence,
		attributes.technical - role.attributes.technical
	]
	var val = 1.0
	for res in results:
		if res < 0:
			val += .1 * res
	for dem in demerits:
		val -= .1
	if role.team.size() > 0:
		var subs = 0.0
		for t in role.team:
			subs += t.get_productivity()
		val *= subs / float(role.team.size())
	return val
