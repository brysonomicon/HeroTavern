class_name Character
extends Resource

@export var character_name: String = ""

@export_group("Class Info")
@export var character_class: CharacterClass
@export var stats: Dictionary[StatType, int]
@export var skills: Array[Skill]

@export_group("Sprite Info")
@export var parts: Dictionary[Slot, CharacterPart] = {}
@export var part_colors: Dictionary[Slot, Color] = {}

static var default_parts: Dictionary[Slot, CharacterPart] = {
	Slot.BASE: 	load("res://components/character_parts/bases/default/boofy.tres") as CharacterPart,
	Slot.EYES: 	load("res://components/character_parts/eyes/default/eyes.tres") as CharacterPart,
	Slot.HAIR: 	load("res://components/character_parts/hair/default/bald.tres") as CharacterPart,
	Slot.HELMET:load("res://components/character_parts/helmets/default/helmetless.tres") as CharacterPart,
	Slot.SHIRT: load("res://components/character_parts/shirts/default/shirtless.tres") as CharacterPart,
	Slot.GLOVES:load("res://components/character_parts/gloves/default/gloves.tres") as CharacterPart,
	Slot.PANTS: load("res://components/character_parts/pants/default/shorts.tres") as CharacterPart,
	Slot.SHOES: load("res://components/character_parts/shoes/default/boots.tres") as CharacterPart,
}

enum Slot { BASE, EYES, HAIR, HELMET, SHIRT, GLOVES, PANTS, SHOES }
enum StatType { STR, DEX, CON, INT, WIS, CHA }

const STAT_MIN: int = 3
const STAT_MAX: int = 18
const KEY_STAT_MIN: int = 14

func _to_string() -> String:
	var lines: PackedStringArray = []
	lines.append("%s the %s" % [character_name, character_class.display_name if character_class else "classless swine"])
	
	var stat_stuff: PackedStringArray = []
	for stat in StatType:
		stat_stuff.append("%s %d" % [stat, stats.get(StatType[stat], 0)])
	lines.append(" " + " ".join(stat_stuff))
	
	var skill_stuff: PackedStringArray = []
	for skill in skills:
		skill_stuff.append(skill.display_name)
	lines.append(" " + " ".join(skill_stuff))
	
	return "\n".join(lines)
func _init(creator = null) -> void:
	for required in Slot.values():
		if parts.get(required) == null:
			self.parts[required] = Character.default_parts[required]
	if creator:
		creator.populate(self)
