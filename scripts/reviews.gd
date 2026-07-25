extends Control

@onready var score: Label = $HBoxContainer/RatingScore
@onready var reviews: Control = $Reviews/VBoxContainer

@export var review_scene: PackedScene

func _ready():
	_on_hierarchy_focus_changed(OrgData.top)

func _on_hierarchy_focus_changed(role: Role) -> void:
	for child in reviews.get_children():
		reviews.remove_child(child)
	var rating_total = 0
	for review in role.employee.reviews:
		rating_total = review.stars
		var inst = review_scene.instantiate() as Control
	if role.employee.reviews.size() == 0:
		score.text = "N/A"
	else:
		rating_total = rating_total / role.employee.reviews.size()
		score.text = Attributes.attribute_stars(rating_total)
