class_name Initiative
extends Button

signal started
signal ended

@onready var timer: Timer = $Timer
@onready var progress: TextureProgressBar = $MarginContainer/HBoxContainer/TextureProgressBar
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var description_label: Label = $MarginContainer/HBoxContainer/Label2
@onready var sprite: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var effect_label: Label = $MarginContainer/HBoxContainer/TextureProgressBar/HBoxContainer/Label2

@export var attributes: Attributes
@export var wait_time: float
@export var title: String
@export_multiline() var description: String
@export var picture: Texture2D
@export var demerit: Demerit

var running: bool

func _ready():
	label.text = title
	description_label.text = description
	sprite.texture = picture
	timer.wait_time = wait_time
	timer.timeout.connect(finish_initiative)
	pressed.connect(start_initiative)

func _physics_process(delta: float) -> void:
	if running:
		progress.value = 1.0 - timer.time_left / timer.wait_time

func start_initiative():
	timer.start()
	disabled = true
	running = true
	started.emit(self)

func finish_initiative():
	timer.stop()
	running = false
	progress.value = 0
	ended.emit(self)

func check_employee(boss: Employee):
	var val: int = 0
	for employee in boss.role.worker_team():
		var fails: int = 0
		var dif = employee.attributes.diff(attributes)
		for d in dif:
			if d < 0:
				fails += 1
		if fails > 1:
			val += 1
	effect_label.text = "%d" % val
