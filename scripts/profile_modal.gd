class_name ProfileModal
extends Control

@onready var close_button: Button = $Control/Button

var portrait: PortraitButton

func _ready():
	SignalBus.highlight.connect(set_employee)
	close_button.pressed.connect(hide)

func set_employee(target: PortraitButton):
	portrait = target
	#var rect := get_global_rect()
	#var bounds := get_parent_control().get_global_rect()
	#var displacement := portrait.size / 1.5
	#global_position.x = portrait.global_position.x + portrait.size.x - (displacement.x / 6.0)
	#global_position.y = portrait.global_position.y - rect.size.y + displacement.y
	# reset rect to updated position
	#rect = get_global_rect()
	#if not bounds.encloses(rect):
		## flip x displacement if past half way
		#if rect.position.x + rect.size.x > bounds.position.x + (bounds.size.x / 2.0):
			#global_position.x = portrait.global_position.x - rect.size.x + (displacement.x / 6.0)
			#if global_position.x < bounds.position.x:
				#global_position.x += displacement.x
		## just clamp y
		#global_position.y = clampf(global_position.y, bounds.position.y, bounds.position.y + bounds.size.y - rect.size.y)
	show()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.is_pressed():
		if not get_global_rect().has_point(get_global_mouse_position()):
			hide()
