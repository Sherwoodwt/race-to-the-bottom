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
@onready var pause_button: Button = $Pause

@export var target_budget_diff: int
@export var portrait_scene: PackedScene

var quarter_counter: int
var productivity: float
var budget: int
var target_budget: int
var budget_total: int

func _ready() -> void:
	quarter_counter = 1
	OrgData.productivity_changed.connect(update_productivity)
	SignalBus.fired.connect(func(_e): update_productivity())
	pause_button.pressed.connect(func(): SignalBus.pause.emit())
	update_productivity()

func _physics_process(delta: float) -> void:
	target_budget_label.text = "$%dK" % target_budget
	budget_label.text = "$%dK" % budget
	var dif = target_budget - budget
	budget_diff_label.text = "$%dK" % dif
	budget_diff_label.add_theme_color_override("font_color", Color.DARK_RED if dif < 0 else Color.WEB_GREEN)
	target_productivity_label.text = "%d%%" % int(OrgData.PRODUCTIVITY_MIN * 100)
	productivity_label.text = "%d%%" % int(productivity * 100)

func update_productivity():
	productivity = OrgData.top.employee.get_productivity()
	budget = OrgData.get_total_budget()
	target_budget = (budget - target_budget_diff)
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

func _on_day_timer_timeout() -> void:
	progress.value -= 1
	if progress.value <= progress.min_value:
		if budget > target_budget or productivity < OrgData.PRODUCTIVITY_MIN:
			SignalBus.lose.emit("You've failed to meet the quarterly budget and productivity goals. You've been terminated.")
		# save budget earned progress
		budget_total = target_budget - budget
		budget_total_label.text = "$%dK" % budget_total
		budget_total_label.add_theme_color_override("font_color", Color.DARK_RED if budget_total < 0 else Color.WEB_GREEN)
		
		# reset values and start new quarter
		progress.value = progress.max_value
		quarter_counter += 1
		SignalBus.quarter_end.emit()
		target_budget_diff += 5
		update_productivity()
	
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
