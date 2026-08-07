extends Control

@onready var day_timer: Timer = $DayTimer
@onready var progress: TextureProgressBar = $Panel/MarginContainer/HBoxContainer/VBoxContainer/QuarterTimer
@onready var quarter_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Quarter
@onready var day_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Days
@onready var target_budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer/TargetBudget
@onready var budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer2/Budget
@onready var target_productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer/TargetProductivity
@onready var productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer2/Productivity

@export var target_budget: int
@export var target_productivity: float

var quarter_counter: int
var productivity: float
var budget: int

func _ready() -> void:
	quarter_counter = 1
	OrgData.productivity_changed.connect(update_productivity)
	update_productivity()

func _physics_process(delta: float) -> void:
	target_budget_label.text = "$%d" % (target_budget * 1000)
	budget_label.text = "$%d" % (budget * 1000)
	target_productivity_label.text = "%d%%" % int(target_productivity * 100)
	productivity_label.text = "%d%%" % int(productivity * 100)

func update_productivity():
	productivity = OrgData.top.employee.get_productivity()
	budget = OrgData.get_total_budget()

func _on_day_timer_timeout() -> void:
	progress.value -= 1
	if progress.value <= progress.min_value:
		if budget > target_budget or productivity < target_productivity:
			print("LOSER")
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
