class_name ReviewDisplay
extends Control

@onready var author: Label = $Review/VBoxContainer2/Author
@onready var score: Label = $Review/VBoxContainer/Score
@onready var text: Label = $Review/Text
@onready var role_text: Label = $Review/VBoxContainer/Label3
#@onready var portrait: PortraitDisplay = $Review/Portrait
@onready var portrait: PortraitButton = $Review/VBoxContainer2/PortraitButton

func setup(review: Review):
	author.text = "%s" % review.author.name
	score.text = Attributes.attribute_stars(review.stars)
	if review.stars < 3:
		score.add_theme_color_override("font_color", Color.DARK_RED)
	else:
		score.add_theme_color_override("font_color", Color.WEB_GREEN)
		
	text.text = "\"%s\"" % review.description
	var rel_role = "coworker"
	if review.target.role.boss.employee == review.author:
		rel_role = "boss"
	if review.target.role.team.find_custom(func(r): return r.employee == review.author) >= 0:
		rel_role = "subordinate"
	role_text.text = "%s's\n%s" % [review.target.name, rel_role]
	#portrait.set_employee(review.author)
	portrait.set_role(review.author.role)
