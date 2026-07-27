class_name Review
extends Resource

#read by file
@export var about_boss: bool
@export var about_subordinate: bool
@export var stars: int
@export_multiline() var description: String

@export var author: Employee
