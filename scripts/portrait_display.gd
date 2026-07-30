class_name PortraitDisplay
extends TextureRect

@onready var hair_sprite: TextureRect = $Hair
@onready var facial_hair_sprite: TextureRect = $FacialHair
@onready var accessory_sprite: TextureRect = $Accessory

var portrait: Portrait

func reset():
	hair_sprite.texture = portrait.hair
	facial_hair_sprite.texture = portrait.facial_hair
	accessory_sprite.texture = portrait.accessory
