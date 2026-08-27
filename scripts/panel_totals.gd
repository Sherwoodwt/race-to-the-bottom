extends Node

@onready var tasks: Button = $Tasks
@onready var money: TextureProgressBar = $Button/HBoxContainer3/HBoxContainer/Money
@onready var productivity: TextureProgressBar = $Button/HBoxContainer3/HBoxContainer2/Productivity
@onready var q_time: TextureProgressBar = $Button/HBoxContainer3/QTime

func _ready() -> void:
	SignalBus.new_quarter.connect(func(_i): reset())
	SignalBus.day_end.connect(func(_i): refresh())
	SignalBus.productivity_changed.connect(refresh)
	SignalBus.tasks_updated.connect(refresh)
	
	productivity.max_value = TaskData.PRODUCTIVITY_MIN * 100
	q_time.max_value = TaskData.QUARTER_DAYS
	reset()

func refresh():
	tasks.text = "Tasks:%d" % TaskData.tasks.size()
	money.value = money.max_value - (TaskData.budget - TaskData.target_budget)
	productivity.value = (TaskData.productivity * 100) - productivity.max_value
	q_time.value = TaskData.cur_day

func reset():
	money.max_value = TaskData.target_budget_diff
	money.value = 0
