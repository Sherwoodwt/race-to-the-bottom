extends Control

@onready var timer: Timer = $Q_Timer
func _ready():
	timer.timeout.connect(end_quarter)
	timer.start()

func end_quarter():
	print("Quarter is over")
	# TODO: Pop up here with status
	timer.start()
