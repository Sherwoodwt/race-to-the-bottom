extends Control

@onready var timer: Timer = $Timer
@onready var portraits: Array[PortraitDisplay] = [$MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait2, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait3, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait4, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait5, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait6, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait7, $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Portrait8]
@onready var main_portrait: PortraitDisplay = $MarginContainer/VBoxContainer/PanelContainer2/Control/Portrait
@onready var you: PortraitDisplay = $PanelContainer/Portrait
@onready var mute_button: Button = $MuteButton
@onready var talk_progress: TextureProgressBar = $TalkProgress
@onready var lose_progress: TextureProgressBar = $LoseProgress

@export var mute_sprite: Texture2D
@export var unmute_sprite: Texture2D
@export var unmuted_count: int
@export var muted_count: int
@export var min_time: float
@export var max_time: float

var muted: bool
var talking: bool
# temp slot for holding portrait of person replaced by you when you are talking
var temp: Portrait
# counter for when to start penalizing when unmuted
var counter: int

func _ready():
	muted = true
	mute_button.icon = mute_sprite
	mute_button.pressed.connect(toggle_mute)
	timer.timeout.connect(handle_timeout)
	reset_timer()
	for p in portraits:
		p.set_portrait(PortraitGenerator.generate_portrait())
	main_portrait.set_portrait(PortraitGenerator.generate_portrait())
	you.set_portrait(OrgData.top.employee.portrait)
	SignalBus.quarter_end.connect(func(): lose_progress.value = 0)
	talk_progress.hide()

func _physics_process(_delta: float) -> void:
	if talking:
		if muted:
			counter += 1
			if counter >= muted_count:
				counter = muted_count
				lose_progress.value += 1
		else:
			if is_visible_in_tree():
				talk_progress.value += 1
			else:
				lose_progress.value += 1
		if talk_progress.value >= talk_progress.max_value:
			counter = 0
			talking = false
			talk_progress.hide()
			talk_progress.value = 0
			main_portrait.set_portrait(temp)
			reset_timer()
	else:
		if not muted:
			counter += 1
			if counter >= unmuted_count:
				counter = unmuted_count
				lose_progress.value += .5
	if lose_progress.value >= lose_progress.max_value:
		SignalBus.lose.emit("Your performance in the daily meetings has been embarrassing. You have been terminated.")

func toggle_mute():
	muted = !muted
	mute_button.icon = mute_sprite if muted else unmute_sprite
	counter = 0

func handle_timeout():
	var roll := randf()
	var new_target: PortraitDisplay
	if roll < .5:
		new_target = portraits.pick_random()
		reset_timer()
	else:
		counter = 0
		timer.stop()
		SignalBus.call_alert.emit()
		new_target = you
		talk_progress.show()
		talking = true
	temp = main_portrait._portrait
	main_portrait.set_portrait(new_target._portrait)
	if new_target != you:
		new_target.set_portrait(temp)

func reset_timer():
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()
