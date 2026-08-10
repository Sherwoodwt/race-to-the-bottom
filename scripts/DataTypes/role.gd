class_name Role
extends Resource

@export var name: String
@export var level: int # represents level in the hierarchy. 0 has no team
@export var boss: Role
@export var team: Array[Role]
@export var attributes: Attributes # ideal attributes for the job
@export var employee: Employee
@export var salary_range: Vector2i

# given a child, finds next child in team, or previous if specified. Need to have employee
func find_neighbor(role: Role, previous: bool = false) -> Role:
	var emp_team = employee_team()
	var i = emp_team.find(role.employee)
	if i < 0:
		return null
	i += 1 if !previous else -1
	if i < 0 or i >= emp_team.size():
		return null
	return emp_team[i].role

func employee_team() -> Array[Employee]:
	return team \
		.filter(func(c): return c.employee) \
		.map(func(c): return c.employee)

# return all worker level employees in hierarchy
func worker_team() -> Array[Employee]:
	var all: Array[Employee]
	if team.size() == 0:
		return [employee]
	for t in team:
		all.append_array(t.worker_team())
	return all

# return all manager employees in hierarchy (have team size > 0)
func manager_team() -> Array[Employee]:
	if team.size() == 0:
		return []
	var all: Array[Employee] = [employee]
	for t in team:
		all.append_array(t.manager_team())
	return all
