class_name Employee
extends Resource

signal productivity_changed

@export var name: String
@export var role: Role
@export var salary: int
@export var attributes: Attributes

var demerits: Array[Demerit]
var productivity_demerit: Demerit
var team_demerit: Demerit
var reviews: Array[Review]
var portrait: Portrait

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
	#employee.attributes = Attributes.make_comperable(role.attributes)
	employee.attributes = Attributes.generate()
	employee.portrait = PortraitGenerator.generate_portrait()
	employee.productivity_demerit = Demerit.new()
	employee.productivity_demerit.text = "incapatability with role"
	employee.team_demerit = Demerit.new()
	employee.team_demerit.text = "failure of subordinates"
	employee.demerits.append(employee.productivity_demerit)
	employee.demerits.append(employee.team_demerit)
	return employee

func check_initiative(initiative: Initiative) -> bool:
	var ini := initiative.attributes
	var rel = attributes.reliability - ini.reliability
	var soc = attributes.sociability - ini.sociability
	var com = attributes.competence - ini.competence
	var tec = attributes.technical - ini.technical
	return rel + soc + com + tec < 0

func apply_initiative(initiative: Initiative):
	if role.team.size() == 0:
		if role.employee.check_initiative(initiative):
			demerits.append(initiative.demerit.duplicate())
			productivity_changed.emit()
	else:
		for member in role.employee_team():
			member.apply_initiative(initiative)

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
	productivity_demerit.value = 1 - get_attribute_compatability()
	if role.team.size() > 0:
		var subs = 0.0
		for e in role.employee_team():
			subs += e.get_productivity()
		team_demerit.value = 1 - snappedf(subs / float(role.team.size()), .1)
		team_demerit.value = snappedf(team_demerit.value / 2, .1)
	var val = 1.0
	for dem in demerits:
		val -= dem.value
	return val

func reset_demerits():
	demerits = demerits.filter(func(d): return !d.temporary)

func get_budget() -> int:
	var budget = salary
	for person in role.employee_team():
		budget += person.get_budget()
	return budget

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
# for new hires also generate reviews of self on those empoyees
func generate_reviews(new_hire: bool = false) -> void:
	if role.boss:
		# handle boss
		if role.boss != OrgData.top and randf() > .8:
			role.boss.employee.reviews.append(make_review(role.boss.employee, false, true))
			if new_hire:
				reviews.append(role.boss.employee.make_review(self, true, false))
	
		# handle neighbors
		for neighbor in role.boss.employee_team():
			if neighbor != self and randf() > .5:
				neighbor.reviews.append(make_review(neighbor, false, false))
				if new_hire:
					reviews.append(neighbor.make_review(self, false, false))
	
	# handle team
	for sub in role.employee_team():
		if randf() > .6 or sub.get_attribute_compatability() < .6:
			sub.reviews.append(make_review(sub, true, false))
			if new_hire:
				reviews.append(sub.make_review(self, false, true))

func make_review(other: Employee, exclude_boss: bool, exclude_subordinate: bool):
	var ability = int(other.get_attribute_compatability() * 5)
	var min_opinion = clampi(ability - 2, 0, 5)
	var max_opinion = clampi(ability, 0, 5)
	var review = ReviewGenerator.random_review(other, min_opinion, max_opinion, exclude_boss, exclude_subordinate)
	review.author = self
	return review

func format_text(text: String):
	return text.replace("[NAME]", name)
