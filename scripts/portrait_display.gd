class_name PortraitDisplay
extends TextureRect

@onready var hair_sprite: TextureRect = $Hair
@onready var facial_hair_sprite: TextureRect = $FacialHair
@onready var accessory_sprite: TextureRect = $Accessory
@onready var filter: TextureRect = $Filter

#can be null, but needed for color filter update
var _employee: Employee
var _portrait: Portrait
var start_g: float

func _ready():
	OrgData.productivity_changed.connect(update_color)
	start_g = filter.modulate.g

func set_employee(employee: Employee):
	_employee = employee
	set_portrait(_employee.portrait)
	if employee != OrgData.top.employee:
		update_color()

func set_portrait(portrait: Portrait):
	_portrait = portrait
	hair_sprite.texture = portrait.hair
	facial_hair_sprite.texture = portrait.facial_hair
	accessory_sprite.texture = portrait.accessory

func update_color():
	if not _employee:
		return
	var prod = _employee.get_productivity()
	filter.modulate.a = 1 - prod
	filter.modulate.g = start_g
	if prod < OrgData.PRODUCTIVITY_MIN:
		filter.modulate.g = 0
		filter.modulate.a = .5
