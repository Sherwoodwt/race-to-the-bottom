class_name TextPortraitButton
extends PortraitButton

@onready var button_text: Label = $Label

func set_role(role: Role):
	button_text.text = "%s\n%s" % [role.employee.name, role.name]
	super(role)
