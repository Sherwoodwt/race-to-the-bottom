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
	if review.stars < 3:
		score.add_theme_color_override("font_color", Color.DARK_RED)
	else:
		score.add_theme_color_override("font_color", Color.WEB_GREEN)
		
	text.text = review.description
	#portrait.set_employee(review.author)
	portrait.set_role(review.author.role)
