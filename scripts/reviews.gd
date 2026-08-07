class_name Reviews
extends Control

@onready var score: Label = $HBoxContainer/RatingScore
@onready var reviews: Control = $Reviews/VBoxContainer

@export var review_scene: PackedScene

func _ready():
	SignalBus.highlight.connect(_on_hierarchy_focus_changed)

func _on_hierarchy_focus_changed(target: PortraitButton) -> void:
	var role = target.role
	if not role.employee:
		return
	for child in reviews.get_children():
		child.queue_free.call_deferred()
	var rating_total: int = 0
	for review in role.employee.reviews:
		rating_total += review.stars
		var inst = review_scene.instantiate() as ReviewDisplay
		reviews.add_child(inst)
		inst.setup(review)
	if role.employee.reviews.size() == 0:
		score.text = "N/A"
	else:
		rating_total = rating_total / role.employee.reviews.size()
		score.text = Attributes.attribute_stars(rating_total)
