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
		
@export var stats: Dictionary[StatType, int]
@export var skills: Array[Skill]

@export_group("Sprite Info")
@export var skin_color: Color = Color.WHITE
@export var eye_color: Color = Color.SADDLE_BROWN
@export var parts: Dictionary[Slot, CharacterPart] = {}

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

# CB: Should we just remove this? I've made it a getter for now.
var class_label: String:
	get: return _character_class.display_name

enum Slot { BASE, EYES, HAIR, HELMET, SHIRT, GLOVES, PANTS, SHOES }
enum StatType { STR, DEX, CON, INT, WIS, CHA }

const STAT_MIN: int = 3
const STAT_MAX: int = 18
const KEY_STAT_MIN: int = 14

func _init(creator = null) -> void:
	for required in Slot.values():
		if parts[required] == null:
			self.parts[required] = Character.default_parts[required]
	if creator:
		creator.populate(self)
