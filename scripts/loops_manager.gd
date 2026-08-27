extends Node

const DAY_LENGTH := 3 # seconds
const MAX_DAYS := 90
const MIN_TASK_TIME := 10
const MAX_TASK_TIME := 30

@onready var day_timer: Timer = $DayTimer
@onready var quarter_progress: ProgressBar = $ProgressBar # days of quarter
@onready var task_timer: Timer = $TaskTimer

var cur_quarter: int

func _ready():
	day_timer.wait_time = DAY_LENGTH
	quarter_progress.max_value = MAX_DAYS
	day_timer.timeout.connect(next_day)
	task_timer.timeout.connect(func(): SignalBus.task_timeout.emit(quarter_progress.value))
	reset_task_timer()
	quarter_progress.value = quarter_progress.max_value

func next_day():
	quarter_progress.value += 1
	if quarter_progress.value <= 0:
		quarter_progress.value = quarter_progress.max_value
		cur_quarter += 1
		SignalBus.new_quarter.emit(cur_quarter)
		reset_task_timer()
		SignalBus.alert.emit("It is now Quarter %d" % cur_quarter)
	SignalBus.day_end.emit(quarter_progress.value)

func reset_task_timer():
	task_timer.wait_time = randf_range(MIN_TASK_TIME, MAX_TASK_TIME)
	task_timer.start()
