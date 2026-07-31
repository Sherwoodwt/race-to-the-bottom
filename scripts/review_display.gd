class_name ReviewDisplay
extends Control

@onready var author: Label = $VBoxContainer/Author
@onready var score: Label = $VBoxContainer/Score
@onready var text: Label = $Text
@onready var portrait: PortraitDisplay = $Control/Portrait

func setup(review: Review):
	author.text = review.author.name
	score.text = Attributes.attribute_stars(review.stars)
	text.text = review.description
	portrait.set_portrait(review.author.portrait)
