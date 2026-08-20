extends Control

@onready var portrait_display: PortraitDisplay = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Portrait
@onready var hair_left: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
@onready var hair_right: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Button
@onready var accessory_left: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button2
@onready var accessory_right: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Button2
@onready var facial_hair_left: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button3
@onready var facial_hair_right: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Button3
@onready var name_label: TextEdit = $PanelContainer/MarginContainer/VBoxContainer/Control/TextEdit
@onready var randomize_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Button
@onready var confirm_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Button2

@export var game_scene: PackedScene

var portrait: Portrait
var cur_hair: int
var cur_accessory: int
var cur_facial_hair: int
var hairs: Array[Texture2D]
var accessories: Array[Texture2D]
var facial_hairs: Array[Texture2D]

func _ready():
	SignalBus.open_creator.connect(show)
	portrait = Portrait.new()
	hairs = [null]
	hairs.append_array(PortraitGenerator.hairs.duplicate_deep())
	accessories = [null]
	accessories.append_array(PortraitGenerator.accessories.duplicate_deep())
	facial_hairs = [null]
	facial_hairs.append_array(PortraitGenerator.facial_hairs.duplicate_deep())
	randomize_button.pressed.connect(random_reset)
	confirm_button.pressed.connect(start_game)
	hair_left.pressed.connect(func(): cycle("hair", -1))
	hair_right.pressed.connect(func(): cycle("hair", 1))
	accessory_left.pressed.connect(func(): cycle("accessory", -1))
	accessory_right.pressed.connect(func(): cycle("accessory", 1))
	facial_hair_left.pressed.connect(func(): cycle("facial_hair", -1))
	facial_hair_right.pressed.connect(func(): cycle("facial_hair", 1))
	random_reset()

func random_reset():
	name_label.text = NameGenerator.random_name()
	cur_hair = randi_range(0, hairs.size() - 1)
	cur_accessory = randi_range(0, accessories.size() - 1)
	cur_facial_hair = randi_range(0, facial_hairs.size() - 1)
	refresh()

func start_game():
	OrgData.top.employee.portrait = portrait
	OrgData.top.employee.name = name_label.text
	OrgData.reset(OrgData.top)
	var inst = game_scene.instantiate()
	add_sibling(inst)
	hide()

# (i - 1 + size) % size => the idea is that going below 0 it cycles
func cycle(type: String, inc: int):
	if type == "hair":
		var s = hairs.size()
		cur_hair = (cur_hair + inc + s) % s
	elif type == "accessory":
		var s = accessories.size()
		cur_accessory = (cur_accessory + inc + s) % s
	elif type == "facial_hair":
		var s = facial_hairs.size()
		cur_facial_hair = (cur_facial_hair + inc + s) % s
	refresh()

func refresh():
	portrait.hair = hairs[cur_hair]
	portrait.accessory = accessories[cur_accessory]
	portrait.facial_hair = facial_hairs[cur_facial_hair]
	portrait_display.set_portrait(portrait)
