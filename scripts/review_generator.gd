extends Node

var reviews_file = "res://scripts/reviews.txt"

var reviews: Array[Review]

func _ready():
	var file = FileAccess.open(reviews_file, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			if line.is_empty():
				break
			var args = line.split("; ")
			var review = Review.new()
			review.about_boss = args[0] == "boss"
			review.about_subordinate = args[0] == "subordinate"
			review.stars = int(args[1])
			review.description = args[2]
			reviews.append(review)
		file.close()

func random_review(min: int, max: int, exclude_boss: bool, exclude_subordinate: bool) -> Review:
	return reviews \
		.filter(func(r): return !r.about_boss if exclude_boss else true) \
		.filter(func(r): return !r.about_subordinate if exclude_subordinate else true) \
		.filter(func(r): return r.stars >= min and r.stars <= max) \
		.pick_random() \
		.duplicate()
