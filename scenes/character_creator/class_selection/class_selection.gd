extends Control

signal class_selected(class_data: Dictionary)
signal complete

@export var title: String = "Class Selection"
@export var classes: Array[CharacterClass]
@export var button_container: VBoxContainer
@export var name_label: Label
@export var description_label: Label

var _selected_class: CharacterClass
var _button_group: ButtonGroup

func _ready() -> void:
	_button_group = ButtonGroup.new()
	for item in classes:
		var button: Button = Button.new()
		button.text = item.display_name
		button.toggle_mode = true
		button.button_group = _button_group
		button.pressed.connect(_on_class_pressed.bind(item))
		button_container.add_child(button)
		
#region signal handlers

func _on_class_pressed(character_class: CharacterClass) -> void:
	_selected_class = character_class
	name_label.text = character_class.display_name
	description_label.text = character_class.description
	class_selected.emit(character_class)
	complete.emit()

#endregion

#region class api

func is_complete() -> bool:
	return _selected_class != null
	
func assign_property(character: Character) -> void:
	character.character_class = _selected_class
	return

#endregion
