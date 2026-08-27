extends Control

@onready var day_timer: Timer = $DayTimer
@onready var progress: TextureProgressBar = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/QuarterTimer
@onready var quarter_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Quarter
@onready var day_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/Days
@onready var target_budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer/TargetBudget
@onready var budget_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer2/Budget
@onready var target_productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer/TargetProductivity
@onready var productivity_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Productivity/HBoxContainer2/Productivity
@onready var budget_diff_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Budget/HBoxContainer3/Budget
@onready var budget_total_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Label2
@onready var fired_count_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Label
@onready var fired_area: Control = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer3/ScrollContainer/HBoxContainer

@export var portrait_scene: PackedScene

func _ready() -> void:
	SignalBus.new_quarter.connect(new_quarter)
	SignalBus.day_end.connect(new_day)
	SignalBus.productivity_changed.connect(update_productivity)
	update_productivity()

func _physics_process(_delta: float) -> void:
	target_budget_label.text = "$%dK" % TaskData.target_budget
	budget_label.text = "$%dK" % TaskData.budget
	var dif = TaskData.target_budget - TaskData.budget
	budget_diff_label.text = "$%dK" % dif
	budget_diff_label.add_theme_color_override("font_color", Color.DARK_RED if dif < 0 else Color.WEB_GREEN)
	target_productivity_label.text = "%d%%" % int(TaskData.PRODUCTIVITY_MIN * 100)
	productivity_label.text = "%d%%" % int(TaskData.productivity * 100)

func update_productivity():
	fired_count_label.text = "Total Fired: %d" % OrgData.fired_employees.size()
	for e in OrgData.fired_employees:
		var vbox = VBoxContainer.new()
		var inst = portrait_scene.instantiate() as PortraitDisplay
		inst.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
		inst.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		vbox.add_child(inst)
		var label = Label.new()
		label.text = e.name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(label)
		fired_area.add_child(vbox)
		inst.set_portrait(e.portrait)

func new_quarter(quarter: int):
	budget_total_label.text = "$%dK" % TaskData.budget_total
	budget_total_label.add_theme_color_override("font_color", Color.DARK_RED if TaskData.budget_total < 0 else Color.WEB_GREEN)
	progress.value = progress.max_value
	if quarter % 10 == 1:
		quarter_label.text = "%dst Quarter" % quarter
	elif quarter % 10 == 2:
		quarter_label.text = "%dnd Quarter" % quarter
	elif quarter % 10 == 3:
		quarter_label.text = "%drd Quarter" % quarter
	else:
		quarter_label.text = "%dth Quarter" % quarter

func new_day(day: int):
	progress.value = TaskData.cur_day
	day_label.text = "%d Days" % (progress.value)
	if progress.value == 1:
		day_label.text = "%d Day" % (progress.value)
