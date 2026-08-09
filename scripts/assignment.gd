extends Control

@onready var day_timer: Timer = $DayTimer
@onready var progress: TextureProgressBar = $Panel/MarginContainer/HBoxContainer/VBoxContainer/QuarterTimer
@onready var quarter_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Quarter
@onready var day_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Days
@onready var target_budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer/TargetBudget
@onready var budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer2/Budget
@onready var target_productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer/TargetProductivity
@onready var productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer2/Productivity
@onready var pause_button: Button = $Pause

@export var target_budget_diff: int

var quarter_counter: int
var productivity: float
var budget: int
var target_budget: int

func _ready() -> void:
	quarter_counter = 1
	OrgData.productivity_changed.connect(update_productivity)
	pause_button.pressed.connect(func(): SignalBus.pause.emit())
	update_productivity()

func _physics_process(delta: float) -> void:
	target_budget_label.text = "$%dK" % target_budget
	budget_label.text = "$%dK" % budget
	target_productivity_label.text = "%d%%" % int(OrgData.PRODUCTIVITY_MIN * 100)
	productivity_label.text = "%d%%" % int(productivity * 100)

func update_productivity():
	productivity = OrgData.top.employee.get_productivity()
	budget = OrgData.get_total_budget()
	target_budget = (budget - target_budget_diff)

func _on_day_timer_timeout() -> void:
	progress.value -= 1
	if progress.value <= progress.min_value:
		if budget > target_budget or productivity < OrgData.PRODUCTIVITY_MIN:
			SignalBus.lose.emit("You've failed to meet the quarterly budget and productivity goals. You've been terminated.")
		progress.value = progress.max_value
		quarter_counter += 1
		SignalBus.quarter_end.emit()
	
	if quarter_counter % 10 == 1:
		quarter_label.text = "%dst Quarter" % quarter_counter
	elif quarter_counter % 10 == 2:
		quarter_label.text = "%dnd Quarter" % quarter_counter
	elif quarter_counter % 10 == 3:
		quarter_label.text = "%drd Quarter" % quarter_counter
	else:
		quarter_label.text = "%dth Quarter" % quarter_counter
	day_label.text = "%d Days" % (progress.value)
	if progress.value == 1:
		day_label.text = "%d Day" % (progress.value)
