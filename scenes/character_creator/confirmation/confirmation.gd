extends Control

signal complete

@export var title: String = "Confirmation"

@export var character_name: LineEdit
@export var class_label: Label
@export var stats_label: Label
@export var skills_label: Label
@export var preview: CharacterSprite

func _ready() -> void:
	character_name.text_changed.connect(_on_name_changed)

#region signal handlers
func _on_name_changed(_new_text: String) -> void:
	complete.emit()
#endregion

#region class api
func review(character: Character) -> void:
	class_label.text = character.character_class.display_name
	stats_label.text = _format_stats(character.stats)
	skills_label.text = _format_skills(character.skills)
	preview.display(character)

func is_complete() -> bool:
	return not character_name.text.strip_edges().is_empty()

func assign_property(character: Character) -> void:
	character.character_name = character_name.text.strip_edges().capitalize()
#endregion

#region internals
func _format_stats(stats: Dictionary) -> String:
	var pairs: Array[String] = []
	for stat_name in Character.StatType:
		var stat: Character.StatType = Character.StatType[stat_name]
		pairs.append("%s %d" % [stat_name, stats.get(stat, 0)])
	return "  ".join(pairs)

func _format_skills(skills: Array[Skill]) -> String:
	if skills.is_empty():
		return "none"
	var names: Array[String] = []
	for skill in skills:
		names.append(skill.display_name)
	return ", ".join(names)
#endregion
