class_name Character
extends Resource

#region Backing fields for properties
var _character_class: CharacterClass
#endregion

@export_group("Class Info")
@export var character_class: CharacterClass:
	get:
		return _character_class
	set(newClass):
		_character_class = newClass
		class_label = _character_class.display_name
@export var class_label: String = ""
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

func _init(creator = null) -> void:
	if creator:
		creator.populate(self)
