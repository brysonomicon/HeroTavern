extends Control

signal complete

@export var title: String = "Skill Selection"
@export var max_skills: int = 3

@export var button_container: VBoxContainer
@export var name_label: Label
@export var description_label: Label

var _skill_pool: Array[Skill] = []
var _selected: Array[Skill] = []
var _character_class: CharacterClass = null

func setup(character_class: CharacterClass) -> void:
	if character_class == null:
		return
	if character_class == _character_class:
		return
	_character_class = character_class
	build_for(character_class)

## signal handlers

func _on_skill_selected(selected: bool, skill: Skill) -> void:
	if selected: 
		_selected.append(skill)
	else:
		_selected.erase(skill)
	_show_description(skill)
	_refresh()
	complete.emit()

## class api

func is_complete() -> bool:
	return not _selected.is_empty()

func assign_property(character: Character) -> void:
	character.skills = _selected.duplicate()

## internals

func build_for(character_class: CharacterClass) -> void:
	_selected.clear()
	for child in button_container.get_children():
		child.queue_free()

	_skill_pool.clear()
	for library in character_class.skill_libraries:
		for skill in library.skills:
			_skill_pool.append(skill)

	for skill in _skill_pool:
		var button: Button = Button.new()
		button.text = skill.display_name
		button.toggle_mode = true
		button.toggled.connect(_on_skill_selected.bind(skill))
		button_container.add_child(button)

	_refresh()
	complete.emit()

func _refresh() -> void:
	var pool_fullness: bool = _selected.size() >= max_skills
	for child in button_container.get_children():
		var button: Button = child as Button
		if button != null and not button.button_pressed:
			button.disabled = pool_fullness


func _show_description(skill: Skill) -> void:
	name_label.text = skill.display_name
	description_label.text = skill.description
