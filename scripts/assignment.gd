extends Control

@onready var quarter_timer: Timer = $QuarterTimer
@onready var progress: TextureProgressBar = $Panel/MarginContainer/VBoxContainer/QuarterTimer
@onready var target_budget: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TargetBudget

func _physics_process(delta: float) -> void:
	progress.value = quarter_timer.time_left


#func _on_quarter_timer_value_changed(value: float) -> void:
	
