extends Control

@export var title: String = "Class Selection"
@export var button_container: VBoxContainer
@export var name_label: Label
@export var description_label: Label

const CLASSES: Array[Dictionary] = [
	{"name": "Warrior", "description": "Melee fighter dude"},
	{"name": "Mage", "description": "Magic caster dude"},
	{"name": "Rogue", "description": "Sneaky stabby dude"},
	{"name": "Cleric", "description": "Buffer healer dude"}
]

var _selected_id: String = ""
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
		
func _on_class_pressed(item: Dictionary) -> void:
	_selected_id = item["name"]
	name_label.text = item["name"]
	description_label.text = item["description"]
	
func assign_property(character: Character) -> void:
	character.class_label = _selected_id
