class_name TaskType
extends Resource

@export var min_attributes: Attributes
@export var max_attributes: Attributes
@export var min_wait_time: float
@export var max_wait_time: float
@export var titles: Array[String]
@export var picture: Texture2D
@export var demerit: Demerit

func generate() -> Task:
	var task = Task.new()
	task.attributes = Attributes.new()
	task.attributes.reliability = randi_range(min_attributes.reliability, max_attributes.reliability)
	task.attributes.sociability = randi_range(min_attributes.sociability, max_attributes.sociability)
	task.attributes.competence = randi_range(min_attributes.competence, max_attributes.competence)
	task.attributes.technical = randi_range(min_attributes.technical, max_attributes.technical)
	
	task.wait_time = randi_range(min_wait_time, max_wait_time)
	task.title = titles.pick_random()
	return task
