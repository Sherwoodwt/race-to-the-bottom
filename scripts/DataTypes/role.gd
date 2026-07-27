class_name Role
extends Resource

@export var name: String
@export var level: int # represents level in the hierarchy. 0 has no team
@export var boss: Role
@export var team: Array[Role]
@export var attributes: Attributes # ideal attributes for the job
@export var employee: Employee
@export var salary_range: Vector2i

# given a child, finds next child in team, or previous if specified
func find_neighbor(role: Role, previous: bool = false):
	var i = team.find(role)
	if i < 0:
		return null
	i += 1 if !previous else -1
	if i < 0 or i >= team.size():
		return null
	return team[i]
