class_name Character
extends Resource

@export var class_label: String = ""
@export var stats: Dictionary[StatType, int]
@export var skills: Array[Skill]

@export var skin_color: Color = Color.WHITE
@export var eye_color: Color = Color.SADDLE_BROWN
@export var parts: Dictionary[Slot, CharacterPart] = {}

enum Slot { EYES, GLOVES, PANTS, SHIRTS, SHOES }
enum StatType { STR, DEX, CON, INT, WIS, CHA }

const STAT_MIN: int = 3
const STAT_MAX: int = 18
const KEY_STAT_MIN: int = 14

func _init(creator = null) -> void:
	if creator:
		creator.populate(self)
