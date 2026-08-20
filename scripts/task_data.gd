extends Node
# TODO: Maybe just get rid of this
const folder := "res://scripts/TaskTypes/"

# current assigned tasks
var task_pool: Array[TaskType]

func _ready() -> void:
	for file in ResourceLoader.list_directory(folder):
		var res := load(folder.path_join(file)) as TaskType
		task_pool.append(res)
