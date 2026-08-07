class_name ReviewDisplay
extends Control

@onready var author: Label = $Review/VBoxContainer/Author
@onready var score: Label = $Review/VBoxContainer/Score
@onready var text: Label = $Review/Text
#@onready var portrait: PortraitDisplay = $Review/Portrait
@onready var portrait: PortraitButton = $Review/PortraitButton

func setup(review: Review):
	author.text = "%s's" % review.author.name
	score.text = Attributes.attribute_stars(review.stars)
	text.text = review.description
	#portrait.set_portrait(review.author.portrait)
	portrait.set_role(review.author.role)
