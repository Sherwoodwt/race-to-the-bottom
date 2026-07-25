class_name Attributes
extends Resource

@export var reliability: int
@export var sociability: int
@export var competence: int
@export var technical: int

static func make_comperable(other: Attributes) -> Attributes:
	var att = Attributes.new()
	att.reliability = clampi(randi_range(other.reliability - 2, other.reliability + 1), 0, 5)
	att.sociability = clampi(randi_range(other.sociability - 2, other.sociability + 1), 0, 5)
	att.competence = clampi(randi_range(other.competence - 2, other.competence + 1), 0, 5)
	att.technical = clampi(randi_range(other.technical - 2, other.technical + 1), 0, 5)
	return att

static func attribute_stars(val: int):
	var text = ""
	for i in range(val):
		text += "*"
	return text
