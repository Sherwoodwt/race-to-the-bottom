extends Node

@onready var options_button: Button = $Panel/Pause

func _ready():
	options_button.pressed.connect(_on_options_pressed)

func _on_options_pressed():
	if !get_tree().paused:
		SignalBus.toggle_pause.emit()

func _on_tutorial_pressed() -> void:
	SignalBus.open_tutorial.emit()

func _on_start_pressed() -> void:
	SignalBus.open_creator.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		SignalBus.pause.emit()
