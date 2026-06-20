extends Control

signal class_selected(class_data: Dictionary)
signal complete

@export var title: String = "Class Selection"
@export var button_container: VBoxContainer
@export var name_label: Label
@export var description_label: Label

const CLASSES: Array[Dictionary] = [
	{"name": "Warrior", "description": "Melee fighter dude", "key_stat": "str"},
	{"name": "Rogue", "description": "Sneaky stabby dude", "key_stat": "dex"},
	{"name": "Barbarian", "description": "Angry fighter dude", "key_stat": "con"},
	{"name": "Mage", "description": "Magic caster dude", "key_stat": "int"},
	{"name": "Cleric", "description": "Buffer healer dude", "key_stat": "wis"},
	{"name": "Bard", "description": "Music talker dude", "key_stat": "cha"}
]

var _selected_class: Dictionary = {}
var _button_group: ButtonGroup

func _ready() -> void:
	_button_group = ButtonGroup.new()
	for item in CLASSES:
		var button: Button = Button.new()
		button.text = item["name"]
		button.toggle_mode = true
		button.button_group = _button_group
		button.pressed.connect(_on_class_pressed.bind(item))
		button_container.add_child(button)
		
## signal handlers

func _on_class_pressed(item: Dictionary) -> void:
	_selected_class = item
	name_label.text = item["name"]
	description_label.text = item["description"]
	class_selected.emit(item)
	complete.emit()

## class api

func is_complete() -> bool:
	return not _selected_class.is_empty()
	
func assign_property(character: Character) -> void:
	character.class_label = _selected_class.get("name")
