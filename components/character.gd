class_name Character
extends Resource

@export var class_label: String = ""
@export var stats: Dictionary

const STATS: Array[String] = ["str", "dex", "con", "int", "wis", "cha"]
const STAT_MIN: int = 3
const STAT_MAX: int = 18
const KEY_STAT_MIN: int = 14

func _init(creator = null) -> void:
	if creator:
		creator.populate(self)
