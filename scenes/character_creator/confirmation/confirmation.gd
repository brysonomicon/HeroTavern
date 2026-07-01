extends Control

@export var title: String = "Confirmation"

@export var class_label: Label
@export var stats_label: Label
@export var skills_label: Label
@export var preview: CharacterTextureBox

## class api

func review(character: Character) -> void:
	class_label.text = character.class_label
	stats_label.text = _format_stats(character.stats)
	skills_label.text = _format_skills(character.skills)
	preview.display(character)

## internals

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
