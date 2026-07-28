class_name Employee
extends Resource

@export var name: String
@export var role: Role
@export var salary: int
@export var attributes: Attributes
@export var demerits: Array[Demerit]
@export var reviews: Array[Review]

# creates top level, player character
static func generate_top() -> Employee:
	var employee = Employee.new()
	employee.name = NameGenerator.random_name()
	employee.attributes = Attributes.make_comperable(employee.role.attributes)
	return employee

static func generate(role: Role) -> Employee:
	var employee = Employee.new()
	employee.name = NameGenerator.random_name()
	employee.role = role
	employee.salary = randf_range(role.salary_range.x, role.salary_range.y)
	employee.attributes = Attributes.make_comperable(role.attributes)
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

# returns percentage
func get_attribute_compatability():
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
	return val

func get_productivity() -> float:
	var val = 1.0 * get_attribute_compatability()
	for dem in demerits:
		val -= .1
	if role.team.size() > 0:
		var subs = 0.0
		for t in role.team:
			subs += t.employee.get_productivity()
		val *= subs / float(role.team.size())
	return val

# what does self think of other
func compare(other: Employee):
	var dif = [
		abs(attributes.reliability - role.attributes.reliability),
		abs(attributes.sociability - role.attributes.sociability),
		abs(attributes.competence - role.attributes.competence),
		abs(attributes.technical - role.attributes.technical),
	]
	return dif

# look at boss, neighbors, and team and make opinions to add to them
func generate_reviews() -> void:
	if role.boss:
		# handle boss
		if role.boss != OrgData.top and randf() > .8:
			role.boss.employee.reviews.append(_make_review(role.boss.employee, false, true))
	
		# handle neighbors
		for neighbor in role.boss.team:
			if neighbor != role and randf() > .5:
				neighbor.employee.reviews.append(_make_review(neighbor.employee, false, false))
	
	# handle team
	for sub in role.team:
		if randf() > .6 or sub.employee.get_attribute_compatability() < .6:
			sub.employee.reviews.append(_make_review(sub.employee, true, false))

func _make_review(other: Employee, exclude_boss: bool, exclude_subordinate: bool):
	var ability = int(other.get_attribute_compatability() * 5)
	var min = clampi(ability - 2, 0, 5)
	var max = clampi(ability, 0, 5)
	var review = ReviewGenerator.random_review(other, min, max, exclude_boss, exclude_subordinate)
	review.author = self
	return review
