class_name Initiative
extends Button

signal initiative_finished(initiative: Initiative)
signal initiative_started(initiative: Initiative)

@onready var progress: TextureProgressBar = $HBoxContainer/TextureProgressBar
@onready var timer: Timer = $Timer
@onready var label: Label = $HBoxContainer/Label
@onready var description_label: Label = $HBoxContainer/Label2
@onready var sprite: TextureRect = $HBoxContainer/TextureRect

@export var attributes: Attributes
@export var wait_time: float
@export var title: String
@export_multiline() var description: String
@export var picture: Texture2D

var started: bool

func _ready():
	label.text = title
	description_label.text = description
	sprite.texture = picture
	timer.wait_time = wait_time
	timer.timeout.connect(finish_initiative)
	pressed.connect(start_initiative)

func _physics_process(delta: float) -> void:
	if started:
		progress.value = 1.0 - timer.time_left / timer.wait_time

func start_initiative():
	timer.start()
	disabled = true
	started = true
	initiative_started.emit(self)

func finish_initiative():
	disabled = false
	started = false
	progress.value = 0
	initiative_finished.emit(self)
