class_name Character
extends Resource

@export var class_label: String = ""

func _init(creator = null) -> void:
	if creator:
		creator.populate(self)
