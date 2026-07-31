class_name PortraitDisplay
extends TextureRect

@onready var hair_sprite: TextureRect = $Hair
@onready var facial_hair_sprite: TextureRect = $FacialHair
@onready var accessory_sprite: TextureRect = $Accessory

var _portrait: Portrait

func set_portrait(portrait: Portrait):
	_portrait = portrait
	hair_sprite.texture = _portrait.hair
	facial_hair_sprite.texture = _portrait.facial_hair
	accessory_sprite.texture = _portrait.accessory
