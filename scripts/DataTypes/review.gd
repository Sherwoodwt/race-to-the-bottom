class_name Review
extends Resource

#read by file
@export var about_boss: bool
@export var about_subordinate: bool
@export var stars: int
@export_multiline() var description: String

@export var author: Employee

# returns formatted description
func format_name(target: Employee) -> String:
	return target.format_text(description)
