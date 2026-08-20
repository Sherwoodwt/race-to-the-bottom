class_name Task
extends Resource

@export var task_type: TaskType
@export var attributes: Attributes
@export var wait_time: float
@export var title: String
@export var picture: Texture2D
@export var demerit: Demerit

var target: Employee
