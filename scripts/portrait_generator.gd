extends Node

@export_dir var hair_dir: String = "res://assets/profiles/hair/"
@export_dir var facial_hair_dir: String = "res://assets/profiles/facial_hair/"
@export_dir var accessory_dir: String = "res://assets/profiles/accessory/"

var hairs: Array[Texture2D]
var facial_hairs: Array[Texture2D]
var accessories: Array[Texture2D]

func _ready() -> void:
	hairs = _load_textures(hair_dir)
	facial_hairs = _load_textures(facial_hair_dir)
	accessories = _load_textures(accessory_dir)

func _load_textures(dir: String) -> Array[Texture2D]:
	var textures: Array[Texture2D]
	for file in ResourceLoader.list_directory(dir):
		if file.ends_with(".png"):
			var pic = load(dir.path_join(file)) as Texture2D
			textures.append(pic)
	return textures

func generate_portrait() -> Portrait:
	var portrait = Portrait.new()
	var hair_i = randi_range(-1, hairs.size()-1)
	if hair_i >= 0:
		portrait.hair = hairs[hair_i]
	var fh_i = randi_range(-12, facial_hairs.size()-1)
	if fh_i >= 0:
		portrait.facial_hair = facial_hairs[fh_i]
	var acc_i = randi_range(-3, accessories.size()-1)
	if acc_i >= 0:
		portrait.accessory = accessories[acc_i]
	return portrait
