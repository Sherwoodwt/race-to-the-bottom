class_name TextPortraitButton
extends PortraitButton

@onready var button_text: Label = $Label

var clicked: bool

func set_role(role: Role):
	button_text.text = "%s\n%s" % [role.employee.name, role.name]
	super(role)

func _physics_process(delta: float) -> void:
	if clicked:
		button_text.add_theme_color_override("font_color", Color.BLACK)
	else:
		button_text.add_theme_color_override("font_color", Color.WHITE)

func _input(event: InputEvent) -> void:
	var e = event as InputEventMouseButton
	if e and get_global_rect().has_point(get_global_mouse_position()):
		clicked = not e.is_released()
