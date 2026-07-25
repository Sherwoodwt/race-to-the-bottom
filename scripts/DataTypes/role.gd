class_name Role
extends Resource

@export var name: String
@export var level: int # represents level in the hierarchy. 0 has no team
@export var boss: Role
@export var team: Array[Role]
@export var attributes: Attributes # ideal attributes for the job
@export var employee: Employee
@export var salary_range: Vector2i
