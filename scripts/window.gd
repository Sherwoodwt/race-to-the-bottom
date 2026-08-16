extends PanelContainer

@onready var close_button: Button = $"MarginContainer2/Button"

func _ready():
	if close_button:
		close_button.pressed.connect(hide)

#func _input(event: InputEvent) -> void:
	#var e = event as InputEventMouseButton
	## TODO: The idea here is to use this for closing/maybe hiding, but is that even needed?
	##if e and e.pressed and e.
