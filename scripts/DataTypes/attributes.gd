class_name Attributes
extends Resource

@export var reliability: int
@export var sociability: int
@export var competence: int
@export var technical: int

var vector: Vector4i

static func make_comperable(other: Attributes) -> Attributes:
	var att = Attributes.new()
	att.reliability = clampi(randi_range(other.reliability - 1, other.reliability + 1), 0, 5)
	att.sociability = clampi(randi_range(other.sociability - 1, other.sociability + 1), 0, 5)
	att.competence = clampi(randi_range(other.competence - 1, other.competence + 1), 0, 5)
	att.technical = clampi(randi_range(other.technical - 1, other.technical + 1), 0, 5)
	att.vector = Vector4i(att.reliability, att.sociability, att.competence, att.technical)
	return att

static func attribute_stars(val: int):
	var text = ""
	for i in range(val):
		text += "*"
	return text

func diff(other: Attributes) -> Array[int]:
	return [
		reliability - other.reliability,
		sociability - other.sociability,
		competence - other.competence,
		technical - other.technical,
	]
