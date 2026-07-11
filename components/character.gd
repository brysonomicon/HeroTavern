class_name Character
extends Resource

@export_group("Class Info")
@export var character_class: CharacterClass
@export var stats: Dictionary[StatType, int]
@export var skills: Array[Skill]

@export_group("Sprite Info")
@export var skin_color: Color = Color.WHITE
@export var eye_color: Color = Color.SADDLE_BROWN
@export var parts: Dictionary[Slot, CharacterPart] = {}

enum Slot { EYES, GLOVES, PANTS, SHIRTS, SHOES }
enum StatType { STR, DEX, CON, INT, WIS, CHA }

const STAT_MIN: int = 3
const STAT_MAX: int = 18
const KEY_STAT_MIN: int = 14

func _to_string() -> String:
	var lines: PackedStringArray = []
	lines.append(character_class.display_name if character_class else "classless swine")
	
	var stat_stuff: PackedStringArray = []
	for stat in StatType:
		stat_stuff.append("%s %d" % [stat, stats.get(StatType[stat], 0)])
	lines.append(" " + " ".join(stat_stuff))
	
	var skill_stuff: PackedStringArray = []
	for skill in skills:
		skill_stuff.append(skill.display_name)
	lines.append(" " + " ".join(skill_stuff))
	
	return "\n".join(lines)
