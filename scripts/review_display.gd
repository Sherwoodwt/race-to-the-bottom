extends Control

@onready var author: Label = $VBoxContainer/Author
@onready var score: Label = $VBoxContainer/Score
@onready var text: Label = $Text

func setup(review: Review):
	author.text = review.author.name
	score.text = Attributes.attribute_stars(review.stars)
	score.text = review.description
