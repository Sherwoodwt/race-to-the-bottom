extends Node
const folder := "res://scripts/TaskTypes/"

const PRODUCTIVITY_MIN := .5
const START_TARGET_DIFF := 150
const QUARTER_DAYS := 90
const DAY_TIME := 3.0

var task_pool: Array[TaskType]
var tasks: Array[Task]
var productivity: float
var budget: int
var target_budget: int
var target_budget_diff: int
var budget_total: int
var cur_day: int
var cur_quarter: int

func _ready() -> void:
	cur_quarter = 1
	cur_day = QUARTER_DAYS
	get_tree().create_timer(DAY_TIME).timeout.connect(new_day)
	SignalBus.new_quarter.connect(new_quarter)
	SignalBus.productivity_changed.connect(update_productivity)
	target_budget_diff = START_TARGET_DIFF
	for file in ResourceLoader.list_directory(folder):
		var res := load(folder.path_join(file)) as TaskType
		task_pool.append(res)
	budget = OrgData.get_total_budget()
	target_budget = budget - target_budget_diff
	update_productivity.call_deferred()

func update_productivity():
	productivity = OrgData.top.employee.get_productivity()
	budget = OrgData.get_total_budget()

func new_quarter(q: int):
	if budget > target_budget or productivity < OrgData.PRODUCTIVITY_MIN:
		SignalBus.lose.emit("You've failed to meet the quarterly budget and productivity goals. You've been terminated.")
	# save budget earned progress
	budget_total = target_budget - budget
	# reset values and start new quarter
	
	target_budget_diff += 5
	target_budget = budget - target_budget_diff
	SignalBus.productivity_changed.emit()

func new_day():
	SignalBus.day_end.emit(cur_day)
	get_tree().create_timer(DAY_TIME).timeout.connect(new_day)
	cur_day -= 1
	if cur_day == 0:
		cur_quarter += 1
		SignalBus.new_quarter.emit(cur_quarter)
