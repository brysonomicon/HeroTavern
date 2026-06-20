extends Control

signal complete

@export var title: String = "Skill Selection"

@export var max_skills: int = 3
@export var skill_pool: Array[Skill]

@export var button_container: VBoxContainer
@export var name_label: Label
@export var description_label: Label

var _selected: Array[Skill] = []

func _ready() -> void:
	for skill in skill_pool:
		var button: Button = Button.new()
		button.text = skill.display_name
		button.toggle_mode = true
		button.toggled.connect(_on_skill_selected.bind(skill))
		button_container.add_child(button)

## signal handlers

func _on_skill_selected(selected: bool, skill: Skill) -> void:
	if selected: 
		_selected.append(skill)
	else:
		_selected.erase(skill)
	_show_description(skill)
	complete.emit()

## class api

func is_complete() -> bool:
	return not _selected.is_empty()

func assign_property(character: Character) -> void:
	character.skills = _selected.duplicate()

## internals

func _show_description(skill: Skill) -> void:
	name_label.text = skill.display_name
	description_label.text = skill.description
