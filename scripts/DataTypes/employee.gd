class_name Employee
extends Resource

@export var name: String
@export var role: Role
@export var salary: float
@export var attributes: Attributes
@export var review: Array[Review]

static func generate(role: Role) -> Employee:
	var employee = Employee.new()
	employee.name = NameGenerator.random_name()
	employee.role = role
	employee.salary = randf_range(role.salary_range.x, role.salary_range.y)
	employee.attributes = Attributes.make_comperable(role.attributes)
	employee.role = role
	return employee
